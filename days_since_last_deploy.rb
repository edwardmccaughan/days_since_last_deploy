require 'rubygems'
require 'git'
require 'date'

repo_directory = "/Developer/betterplace"
tag_date_format = "%Y_%m_%d-%H_%M"


git = Git.open(repo_directory)
most_recent_deploy = git.tags.select{|t| t.name.include?("production_deploy")}.last

date = most_recent_deploy.name.gsub "production_deploy_", ""
time_of_last_deploy = DateTime.strptime(date, tag_date_format)

days_since_last_deploy = (DateTime.now.to_date - time_of_last_deploy.to_date).to_i

puts "it has been #{days_since_last_deploy} days since the last production deploy"