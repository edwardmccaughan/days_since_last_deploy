require 'rubygems'
require 'octokit'
require 'date'
require 'faraday-http-cache'

class GitData 
  def initialize(token=nil)
    if token
      build_octokit_caching
      @client ||= Octokit::Client.new :access_token => token
    end
  end

  def build_octokit_caching
    stack = Faraday::Builder.new do |builder|
      builder.use Faraday::HttpCache
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end
    Octokit.middleware = stack
  end

  def days_since_last_deploy_from_tags_from_github(repo)
    tags = @client.tags repo
    days_since_last_deploy_from_tags tags
  end

  def days_since_last_deploy_from_tags_from_repo(repo_directory)
    git = Git.open(repo_directory)
    git.fetch
    days_since_last_deploy_from_tags git.tags
  end

  def days_since_last_deploy_from_tags(tags)
    production_deploys = tags.select{|t| t.name.include?("production_deploy")}

    most_recent = production_deploys.map(&:name).sort.last

    date = most_recent.gsub "production_deploy_", ""
    tag_date_format = "%Y_%m_%d-%H_%M"
    time_of_last_deploy = DateTime.strptime(date, tag_date_format)

    (DateTime.now.to_date - time_of_last_deploy.to_date).to_i
  end

  def new_activity?(repo_name)
    repo = @client.repo repo_name
    old_updated_at = @repo_updated_at
    @repo_updated_at = repo[:updated_at]

    old_updated_at.present? && old_updated_at != @repo_updated_at
  end
end

