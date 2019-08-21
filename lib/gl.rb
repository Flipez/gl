# frozen_string_literal: true

require 'thor'
require 'gitlab'
require 'tty-spinner'
require 'tty-progressbar'
require 'tty-table'
require 'tty-prompt'
require 'tty-box'
require 'tty-screen'
require 'tty-markdown'

require 'gl/cli'

module Gl
  class Error < StandardError; end
  def self.current_project(project = nil)
    current_remote = project || Gl.remote_url

    if current_remote.empty?
      prompt = TTY::Prompt.new
      prompt.ask('No remote found, please enter a project (like `group/project`)')
    else
      remote_parse[1]
    end
  end

  def self.open_in_browser(url)
    url = "#{Gitlab.endpoint.gsub('api/v4', '')}#{url}"
    `sensible-browser #{url}`
  end

  def self.validate_endpoint!
    return if Net::HTTP.get(URI("#{Gitlab.endpoint}version")) == '{"message":"401 Unauthorized"}'

    puts 'It seems this is not a valid GitLab repository'
    exit(1)
  end

  def self.remote_url
    `git config --get remote.origin.url`.chomp
  end

  def self.remote_parse
    if remote_url.start_with?('git@')
      regexp = %r{git@(.*?)(:|\/)(.*)?(\.git)}
      url = remote_url

      host = url.gsub(regexp, '\1')
      project = url.gsub(regexp, '\3')
    else
      uri = URI(remote_url)
      host = uri.host
      project = uri.path.gsub(%r{\/(.*)\.git$}, '\1')
    end

    if host.nil? || project.nil?
      puts 'Could not discover git remote. Make sure you are in a valid git repository'
      exit(1)
    end

    [host, project]
  end

  def self.remote_base
    remote_parse[0]
  end

  def self.remote_slug
    remote_base.gsub('.', '-')
  end
end
