class AddStarredToBookmarks < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :starred, :boolean
  end

  def self.down
    remove_column :bookmarks, :starred
  end
end
