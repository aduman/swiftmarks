class User < ActiveRecord::Base
  acts_as_authentic

  has_many :bookmarks

  def tags
    bookmarks.tag_counts_on(:tags)
  end
end
