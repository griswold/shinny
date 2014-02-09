# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
["Shinny", "Public Skate"].each do |activity_name|
  Activity.find_or_create_by(name: activity_name)
end
