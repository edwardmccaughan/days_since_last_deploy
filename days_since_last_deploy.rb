require 'rubygems'
require 'git'
require 'date'

def days_since_last_deploy(repo_directory)
  git = Git.open(repo_directory)
  git.fetch

  most_recent_deploy = git.tags.select{|t| t.name.include?("production_deploy")}.last

  date = most_recent_deploy.name.gsub "production_deploy_", ""
  tag_date_format = "%Y_%m_%d-%H_%M"
  time_of_last_deploy = DateTime.strptime(date, tag_date_format)

  (DateTime.now.to_date - time_of_last_deploy.to_date).to_i
end

days = days_since_last_deploy("/Developer/betterplace")
puts "it has been #{days} days since the last production deploy"