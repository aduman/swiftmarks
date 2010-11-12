# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Bookmark.create([
  { 
    :url => "http://www.google.com",
    :title => "Google",
    :description => "Search the web"
  },
  {
    :url => "http://www.amazon.com",
    :title => "Amazon",
    :description => "Shop online"
  }
])
