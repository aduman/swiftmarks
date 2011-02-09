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
end
