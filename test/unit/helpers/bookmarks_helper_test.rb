require 'test_helper'

class BookmarksHelperTest < ActionView::TestCase
  test "formatted_host should return a formatted host for a bookmark with a host" do
    bookmark = Bookmark.new(:url => "http://www.example.com")
    assert "(www.example.com)", formatted_host(bookmark)
  end

  test "formatted_host should return nil for a nil bookmark or host" do
    bookmark = Bookmark.new
    assert_nil formatted_host(bookmark)
  end

  test "next_page_link should not be blank with next page" do
    @bookmarks = Bookmark.limit(2).paginate(:page => 1, :per_page => 1)
    link = next_page_link(hash_for_bookmarks_url(:page => 1))
    assert !link.blank?
  end

  test "next_page_link should be blank without next page" do
    @bookmarks = Bookmark.limit(2).paginate(:page => 1)
    link = next_page_link(hash_for_bookmarks_url(:page => 1))
    assert link.blank?
  end
end
