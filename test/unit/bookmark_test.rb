require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase

  # CLASS METHOD TESTS

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
