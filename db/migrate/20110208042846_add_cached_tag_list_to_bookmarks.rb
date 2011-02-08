class AddCachedTagListToBookmarks < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :cached_tag_list, :string

    Bookmark.all.each do |b| 
      b.tag_list    # Generate tag list
      b.save(false) # Save model to save cached tag list
    end 
  end

  def self.down
    remove_column :bookmarks, :cached_tag_list
  end
end
