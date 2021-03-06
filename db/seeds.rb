# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Steam::Apps.get_all.each do |app|
  Game.find_or_create_by(:game_name => app["name"], :appid => app["appid"])
end

require 'csv'
CSV.parse(File.read('steam_lib_times.csv')).each do |x|
  next if Distribution.where(:description => x[0]).any?
  Distribution.create(:description => x[0], :minutes => x[1], :remote_image_url => x[2])
end