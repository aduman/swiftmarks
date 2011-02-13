require 'test_helper'

class BookmarksHelperTest < ActionView::TestCase
  test "bookmark_url_host should return formatted host when uri is present" do
    bookmark = Bookmark.new(:url => "http://www.example.com")
    assert "(www.example.com)", bookmark_url_host(bookmark)
  end

  test "bookmark_url_host should return an empty string when uri is nil" do
    bookmark = Bookmark.new
    assert "", bookmark_url_host(bookmark)
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
