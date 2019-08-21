# frozen_string_literal: true

module Gl
  class MergeRequests < Thor
    desc 'list', 'list open merge requests'
    option :i
    def list(project = nil)
      if options[:i]
        id = merge_request_dialogue(project)
        mr = merge_requests.select { |merge_request| merge_request.iid == id.to_i }.first
        box = TTY::Box.frame(
          width: TTY::Screen.width,
          height: mr.description.lines.count + 4,
          padding: 1,
          title: { top_center: mr.title[0..TTY::Screen.width - 3],
                   bottom_left: "State: #{mr.state}",
                   bottom_right: "by #{mr.author.name}" }
        ) do
          mr.description
        end
        puts box

        choice = TTY::Prompt.new(interrupt: :exit).select('What to do next?') do |menu|
          menu.choice :open
          menu.choice :merge
          menu.choice :approve
          menu.choice :exit
        end

        case choice.to_sym
        when :open then open_mr_in_browser(mr.iid)
        when :merge then merge(mr.iid)
        when :approve then approve(mr.iid)
        when :exit then exit
        end
      else
        table = TTY::Table.new(%w[IID Author Title],
                               merge_requests_list(project))
        puts table.render(:ascii, padding: [0, 1])
      end
    end

    desc 'approve', 'approves a merge request'
    def approve(iid = nil)
      iid ||= merge_request_dialogue
      begin
        Gitlab.approve_merge_request(Gl.current_project, iid)
      rescue Gitlab::Error::Unauthorized
        TTY::Prompt.new.error('Unable to approve merge request')
      end
    end

    desc 'open', 'opens the merge request overview in your browser'
    def open(iid = nil)
      open_mr_in_browser(iid)
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
    def merge(iid = nil)
      iid ||= merge_request_dialogue.split(' - ')[0]
      Gitlab.accept_merge_request(Gl.current_project,
                                  iid,
                                  squash: options['squash'],
                                  should_remove_source_branch: options['delete-branch'])
    rescue Gitlab::Error::MethodNotAllowed => e
      TTY::Prompt.new.error(
        case e.response_status
        when 405
          'Unable to accept merge request ' \
          '(ie: Work in Progress, Closed, Pipeline Pending Completion, ' \
          'or Failed while requiring Success)'
        else
          "Could not merge due to unknown error: #{e.response_status}"
        end
      )
    end

    private

    def open_mr_in_browser(iid)
      Gl.open_in_browser("#{Gl.current_project}/merge_requests/#{iid}")
    end

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
      prompt.select('Select a merge request', filter: true) do |menu|
        merge_requests_list(project).each do |merge_request|
          menu.choice merge_request.join(' - '), merge_request[0]
        end
      end
    end

    def merge_requests_list(project = nil)
      @merge_requests_list ||= begin
        merge_requests(project).map do |mr|
          [mr.iid, mr.author.name, mr.title]
        end
      end
    end

    def merge_requests(project = nil)
      @merge_requests ||= begin
        Gitlab.merge_requests(Gl.current_project(project),
                              state: :opened).auto_paginate
      end
    end
  end
end
