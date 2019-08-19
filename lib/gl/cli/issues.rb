# frozen_string_literal: true

module Gl
  class Issues < Thor
    desc 'list', 'list open issues'
    option :i
    def list(project = nil)
      issues = Gitlab.issues(Gl.current_project(project), state: :opened).auto_paginate

      issues_list = issues.map do |issue|
        [issue.iid, issue.author.name, issue.title]
      end

      if options[:i]
        prompt = TTY::Prompt.new(interrupt: :exit)
        choice = prompt.select('Open a issue') do |menu|
          issues_list.each do |issue|
            menu.choice issue.join(' - '), issue[0]
          end
        end
        Gl.open_in_browser("#{Gl.current_project}/issues/#{choice}")
      else
        table = TTY::Table.new(%w[IID Author Title],
                               issues_list)
        puts table.render(:ascii, padding: [0, 1])
      end
    end

    desc 'open', 'opens the issues overview in your browser'
    def open(id = nil)
      Gl.open_in_browser("#{Gl.current_project}/issues/#{id}")
    end
  end
end
