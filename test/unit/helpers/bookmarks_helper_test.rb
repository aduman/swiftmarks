require 'test_helper'

class BookmarksHelperTest < ActionView::TestCase
  setup do
    BookmarksHelper.send(:include, ApplicationHelper)
  end

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

  test "toggle_star_link_for should return a star link to the toggle action" do
    bookmark = bookmarks(:starred)
    link = toggle_star_link_for(bookmark)
    assert_match /id="star-#{bookmark.id}"/, link
    assert_match /class="starred"/, link
    assert_match /href="#{toggle_bookmark_url(bookmark)}"/, link
    assert_match /data-type="script"/, link
    assert_match /data-remote="true"/, link
  end
end
