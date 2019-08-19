# frozen_string_literal: true

module Gl
  class Registry < Thor
    desc 'status', 'display statistics about the registry'
    def status
      project = Gl.current_project

      table = TTY::Table.new(header: %w[Registry Tags Size]) do |table|
        registries.each do |registry|
          tags = Gitlab.registry_repository_tags(project, registry.id).auto_paginate

          next if tags.empty?

          tags = tags.map do |tag|
            Gitlab.registry_repository_tag(project, registry.id, tag.name)
          rescue Gitlab::Error::NotFound
            next
          end

          tags_size = tags.flatten.compact.map(&:total_size).inject(0) { |sum, x| sum + x }
          table << [registry.path, tags.count, "#{(tags_size / 1024.0 / 1024.0).round(2)} MB"]
        end
      end
      puts table.render(:ascii, alignments: %i[left right], padding: [0, 1])
    end

    desc 'list', 'list content of the registry'
    def list
      project = Gl.current_project
      table = TTY::Table.new(header: %w[Registry Tag Image_ID Created_at Size]) do |table|
        registries.each do |registry|
          tags = Gitlab.registry_repository_tags(project, registry.id).auto_paginate

          tags = tags.map { |tag| Gitlab.registry_repository_tag(project, registry.id, tag.name) }

          tags.sort_by { |tag| -DateTime.parse(tag.created_at).to_time.to_i }.each do |tag|
            table << [registry.path,
                      tag.name,
                      tag.short_revision,
                      tag.created_at,
                      "#{(tag.total_size / 1024.0 / 1024.0).round(2)} MB"]
          rescue Gitlab::Error::NotFound
            next
          end

        end
      end
      puts table.render(:ascii, alignments: %i[left right], padding: [0, 1])
    end

    private

    def registries
      Gitlab.registry_repositories(Gl.current_project).auto_paginate
    end
  end
end
