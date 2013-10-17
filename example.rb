require 'byebug'
require 'rufus-scheduler'
require_relative 'days_since_last_deploy'


token = "your_github_oauth_key"
github_repo = 'edwardmccaughan/days_since_last_deploy'
repo_directory = "path_to_your_git_repo"


git_data = GitData.new(token)


# days since last deploy:
days =  git_data.days_since_last_deploy_from_tags_from_github(github_repo)
puts "it has been #{days} days since the last production deploy"

# check every 5 seconds for new commits
scheduler = Rufus::Scheduler.new
scheduler.every '5s' do
  puts git_data.new_activity?(github_repo)
end
scheduler.join

loop do
  sleep(1) # Keep your main thread running
end

