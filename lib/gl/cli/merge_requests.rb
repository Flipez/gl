# frozen_string_literal: true

module Gl
  class MergeRequests < Thor
    desc 'list', 'list open merge requests'
    option :i
    def list(project = nil)
      if options[:i]
        id = merge_request_dialogue(project)
        Gl.open_in_browser("#{Gl.current_project}/merge_requests/#{id}")
      else
        table = TTY::Table.new(%w[IID Author Title],
                               merge_requests_list(project))
        puts table.render(:ascii, padding: [0, 1])
      end
    end

    desc 'open', 'opens the merge request overview in your browser'
    def open(id = nil)
      Gl.open_in_browser("#{Gl.current_project}/merge_requests/#{id}")
    end

    desc 'label', 'add a label to a merge request'
    def label(label)
      label_action(label)
    end

    desc 'unlabel', 'remove a label from a merge request'
    def unlabel(label)
      label_action(label)
    end

    desc 'merge', 'accept a merge request'
    method_option 'delete-branch', type: :boolean, default: true, desc: 'Delete branch after merge'
    method_option 'squash', type: :boolean, default: false, desc: 'Squash commits'
    def merge
      Gitlab.accept_merge_request(Gl.current_project,
                                  merge_request_dialogue,
                                  squash: options['squash'],
                                  should_remove_source_branch: options['delete-branch'])
    rescue Gitlab::Error::MethodNotAllowed => e
      case e.response_status
      when 405
        puts 'Unable to accept merge request ' \
             '(ie: Work in Progress, Closed, Pipeline Pending Completion, ' \
             'or Failed while requiring Success)'
      else
        puts "Could not merge due to unknown error: #{e.response_status}"
      end
    end

    private

    def label_action(label)
      id = merge_request_dialogue
      action = caller_locations(1, 1)[0].label

      begin
        Gitlab.create_merge_request_note(Gl.current_project,
                                         id,
                                         "/#{action} ~\"#{label}\"")
      rescue Gitlab::Error::BadRequest
        true
      end
    end

    def merge_request_dialogue(project = nil)
      prompt = TTY::Prompt.new(interrupt: :exit)
      prompt.select('Select a merge request') do |menu|
        merge_requests_list(project).each do |merge_request|
          menu.choice merge_request.join(' - '), merge_request[0]
        end
      end
    end

    def merge_requests_list(project)
      @merge_requests_list ||= begin
        merge_requests = Gitlab.merge_requests(Gl.current_project(project),
                                               state: :opened).auto_paginate

        merge_requests.map do |mr|
          [mr.iid, mr.author.name, mr.title]
        end
      end
    end
  end
end
