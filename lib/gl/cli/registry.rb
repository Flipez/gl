# frozen_string_literal: true

module Gl
  class Registry < Thor
    desc 'status', 'display statistics about the registry'
    def status
      spinner = TTY::Spinner.new('[:spinner] Fetching projects ...')

      results = {}

      spinner.auto_spin
      projects = Gitlab.projects.auto_paginate
      spinner.stop("Found #{projects.count}")

      bar = TTY::ProgressBar.new(
        'processing projects [:bar] :current/:total processed (:percent, :eta remaining)',
        total: projects.size
      )

      projects.each do |project|
        bar.advance(1)
        registries = begin
          Gitlab.registry_repositories(project.id)
                     rescue Gitlab::Error::Forbidden
                       next
        end

        next if registries.empty?

        infos = registries.map do |registry|
          tags = Gitlab.registry_repository_tags(project.id, registry.id)

          next if tags.empty?

          tags = tags.map do |tag|
            Gitlab.registry_repository_tag(project.id, registry.id, tag.name)
          rescue Gitlab::Error::NotFound
            next
          end

          tags
        end

        sizes = infos.flatten.compact.map(&:total_size)

        project_size = sizes.inject(0) { |sum, x| sum + x }
        results[project.path_with_namespace] = (project_size / 1024.0 / 1024.0).round(2)
      end

      bar.finish
      table = TTY::Table.new(['Project', 'Size in MB'], results.sort_by { |_key, value| -value })
      table << ['Total usage', results.values.inject(0) { |sum, x| sum + x }.round(2)]
      puts table.render(:ascii, alignments: %i[left right])
    end
  end
end
