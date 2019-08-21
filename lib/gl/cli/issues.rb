# frozen_string_literal: true

module Gl
  class Issues < Thor
    desc 'list', 'list open issues'
    option :i
    def list(project = nil)
      if options[:i]
        id = issue_dialogue(project)
        Gl.open_in_browser("#{Gl.current_project}/issues/#{id}")
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

    desc 'label', 'add a label to an issue'
    def label(label)
      label_action(label)
    end

    desc 'unlabel', 'remove a label from an issue'
    def unlabel(label)
      label_action(label)
    end

    private

    def label_action(label)
      id = issue_dialogue
      action = caller_locations(1, 1)[0].label

      begin
        Gitlab.create_issue_note(Gl.current_project,
                                 id,
                                 "/#{action} ~\"#{label}\"")
      rescue Gitlab::Error::BadRequest
        true
      end
    end

    def issue_dialogue(project = nil)
      prompt = TTY::Prompt.new(interrupt: :exit)
      prompt.select('Open a issue', filter: true) do |menu|
        issues_list(project).each do |issue|
          menu.choice issue.join(' - '), issue[0]
        end
      end
    end

    def issues_list(project)
      @issues_list ||= begin
        issues = Gitlab.issues(Gl.current_project(project), state: :opened).auto_paginate

        issues.map do |issue|
          [issue.iid, issue.author.name, issue.title]
        end
      end
    end
  end
end
