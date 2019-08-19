# frozen_string_literal: true

require 'gl/cli/registry'
require 'gl/cli/merge_requests'
require 'gl/cli/issues'

module Gl
  class CLI < Thor
    desc 'registry', 'handle registry of the project'
    subcommand 'registry', Registry

    desc 'mr', 'handle merge requests of the project'
    subcommand 'mr', MergeRequests

    desc 'issues', 'handle issues of the project'
    subcommand 'issues', Issues

    def self.setup
      Gitlab.endpoint = "https://#{Gl.remote_base}/api/v4/"
      Gl.validate_endpoint!

      prompt = TTY::Prompt.new

      token = `git config --get gl.#{Gl.remote_slug}.token`.chomp
      if token.empty?
        Gl.open_in_browser('profile/personal_access_tokens')
        token = prompt.mask("Please enter your GitLab token for #{Gl.remote_base}")

        token_name = "gl.#{Gl.remote_slug}.token"
        if prompt.yes?("Do you want to persist the token as #{token_name} to your git config")
          `git config --global --add #{token_name} #{token}`
        end
      end

      Gitlab.private_token = token
    end
  end
end
