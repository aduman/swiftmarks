require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase
  setup do
    @bookmark = bookmarks(:google)
  end

  test "on GET to :index" do
    get :index
    assert_equal assigns(:bookmarks).count, Bookmark.all.count
    assert_response :success
    assert_template "index"
  end

  test "on GET to :new" do
    get :new
    assert_response :success
    assert_template "_form"
  end

  test "on valid POST to :create" do
    post :create, :bookmark => {
      :url => "http://www.yahoo.com",
      :title => "Yahoo",
      :description => "Yahoo Search Engine"
    }

    assert_redirected_to bookmarks_url
  end

  test "on invalid POST to :create" do
    post :create, :bookmark => {}
    assert_template "_form"
  end

  test "on GET to :edit" do
    get :edit, :id => @bookmark.id
    assert_response :success
    assert_template "_form"
  end

  test "on valid POST to :update" do
    post :update, :id => @bookmark.id, :bookmark => {
      :description => "Search Engine"
    }

    assert_redirected_to bookmarks_url
  end

  test "on invalid POST to :update" do
    post :update, :id => @bookmark.id, :bookmark => { :url => nil }
    assert_template "_form"
  end

  test "on POST to :delete" do
    delete :destroy, :id => @bookmark.id
    assert !Bookmark.exists?(@bookmark.id)
    assert_redirected_to bookmarks_url
  end
end
