require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase

  # CLASS METHOD TESTS

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

  test "import should import all bookmarks from a valid file for a user" do
    assert_difference "users(:josh).bookmarks.count" do
      File.open("test/fixtures/valid_bookmarks_to_import.html") do |file|
        Bookmark.import(file, users(:josh).id)
      end
    end
  end

  test "import should raise an exception and not import anything when file has invalid bookmarks" do
    assert_no_difference "users(:josh).bookmarks.count" do
      assert_raise ActiveRecord::RecordInvalid do
        File.open("test/fixtures/invalid_bookmarks_to_import.html") do |file|
          Bookmark.import(file, users(:josh).id)
        end
      end
    end
  end

  # INSTANCE METHOD TESTS

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

  test "should toggle a starred bookmark to unstarred" do
    b = Bookmark.new(:starred => true)
    b.toggle_starred
    assert !b.starred?
  end

  test "should toggle an unstarred bookmark to starred" do
    b = Bookmark.new(:starred => false)
    b.toggle_starred
    assert b.starred?
  end
end
