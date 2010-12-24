class Bookmark < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :url, :title, :user_id
end
