require 'test_helper'

class BookmarksHelperTest < ActionView::TestCase
  test "tag_list_for should return 'Untagged' for a bookmark without tags" do
    bookmark = Bookmark.new
    assert_equal "Untagged", tag_list_for(bookmark)
  end

  test "tag_list_for should return a tag list for a bookmark with tags" do
    bookmark = Bookmark.new(:cached_tag_list => "search, shopping")
    assert_equal "search, shopping", tag_list_for(bookmark)
  end

  test "tag_name_with_count_for should return a name and count for a tag" do
    tag = Bookmark.tag_counts.first
    assert_equal "search (1)", tag_name_with_count_for(tag)
  end

  test "tag_name_with_count_for should return nil without a tag" do
    assert_nil tag_name_with_count_for(nil)
  end

  test "hostname_for should return a bookmark's hostname when present" do
    bookmark = Bookmark.new(:url => "http://www.example.com")
    assert "(www.example.com)", hostname_for(bookmark)
  end

  test "hostname_for should return nil for a bookmark without a host" do
    bookmark = Bookmark.new
    assert_nil hostname_for(bookmark)
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
