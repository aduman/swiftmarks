require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
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

  test "should have a :uri with a valid :url" do
    b = Bookmark.new(:url => "http://www.example.com")
    assert b.uri.is_a?(URI)
  end

  test "should not have a :uri with an invalid :url" do
    b = Bookmark.new
    assert_nil b.uri
  end
end
