require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  test "should validate presence of :url" do
    bookmark = Bookmark.create
    assert bookmark.errors.has_key?(:url)
  end

  test "should validate presence of :title" do
    bookmark = Bookmark.create
    assert bookmark.errors.has_key?(:title)
  end

  test "should validate presence of :user_id" do
    bookmark = Bookmark.create
    assert bookmark.errors.has_key?(:user_id)
  end
end
