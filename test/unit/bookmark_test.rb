require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  test "search should return bookmarks whose title matches a given criteria" do
    bookmarks = Bookmark.search("google")
    assert_equal 1, bookmarks.size
    assert_equal "Google", bookmarks.first.title
  end

  test "search should return bookmarks whose cached_tag_list matches a given criteria" do
    bookmarks = Bookmark.search("shopping")
    assert_equal 1, bookmarks.size
    assert_equal "shopping", bookmarks.first.cached_tag_list
  end

  test "search should return zero results when criteria has no matches" do
    assert_equal 0, Bookmark.search("NO_MATCHES").size
  end

  test "search should return all bookmarks for blank criteria" do
    assert_equal Bookmark.count, Bookmark.search(nil).size
  end

  test "search should always return an anonymous scope" do
    assert Bookmark.search("google").is_a?(ActiveRecord::Relation)
    assert Bookmark.search(nil).is_a?(ActiveRecord::Relation)
  end

  test "should define a per_page with a default value" do
    assert_equal 50, Bookmark.per_page 
  end

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

  test "should validate format of :url" do
    invalid_urls = [
      "ftp://example.com",
      "www.example.com",
      "example.com"
    ]

    valid_urls = [
      "http://example",
      "http://www.example.com",
      "https://www.example.com",
      "http://example.com?foo=a&bar=b",
      "http://example.com?foo=a%20b"
    ]

    invalid_urls.each do |url|
      b = Bookmark.new(:url => url)
      b.valid?
      assert b.errors.has_key?(:url), "#{url} should be invalid"
    end

    valid_urls.each do |url|
      b = Bookmark.new(:url => url)
      b.valid?
      assert !b.errors.has_key?(:url), "#{url} should be valid"
    end
  end

  test "should have a :host with a valid :url" do
    b = Bookmark.new(:url => "http://www.example.com")
    assert_equal "www.example.com", b.host
  end

  test "should not have a :host with an invalid :url" do
    b = Bookmark.new
    assert_nil b.host
  end
end
