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

  test "link_to_next_page should not be blank when next page exists" do
    bookmarks = Bookmark.all.paginate(:page => 1, :per_page => 1)
    controller.params = hash_for_bookmarks_url
    view.instance_variable_set(:@bookmarks, bookmarks)
    assert_match bookmarks_url(:page => 2), view.link_to_next_page
  end

  test "link_to_next_page should be blank when next page does not exist" do
    bookmarks = Bookmark.all.paginate(:page => 1)
    controller.params = hash_for_bookmarks_url
    view.instance_variable_set(:@bookmarks, bookmarks)
    assert view.link_to_next_page.blank?
  end
end
