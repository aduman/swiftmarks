class Bookmark < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  validates_presence_of :url, :title, :user_id
end
