require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase
  setup do
    UserSession.create(users(:josh))
    Bookmark.per_page = 1
  end

  test "index should return a paged set of bookmarks for current user" do
    get :index
    assert_equal %w(Google), assigns(:bookmarks).map(&:title)
    assert_equal %w(search shopping), assigns(:tags).map(&:name)
    assert_response :success
    assert_template "bookmarks/index"
  end

  test "index should allow bookmarks to be searched" do
    get :index, :search => "amazon"
    assert_equal %w(Amazon), assigns(:bookmarks).map(&:title)
    assert_response :success
    assert_template "bookmarks/index"
  end

  test "index should filter bookmarks by tag for current user" do
    get :index, :tag => "shopping"
    assert_equal %w(Amazon), assigns(:bookmarks).map(&:title)
    assert_equal %w(search shopping), assigns(:tags).map(&:name)
    assert_response :success
    assert_template "bookmarks/index"
  end

  test "new should render template new" do
    get :new
    assert_response :success
    assert_template "bookmarks/new"
  end

  test "create should create a bookmark and redirect to the list page" do
    assert_difference "users(:josh).bookmarks.count" do
      post :create, :bookmark => {
        :url => "http://www.yahoo.com",
        :title => "Yahoo",
        :description => "Yahoo Search Engine"
      }
    end

    assert_redirected_to bookmarks_url
  end

  test "create should render new template on invalid POST" do
    assert_no_difference "Bookmark.count" do
      post :create, :bookmark => {}
    end

    assert_template "bookmarks/new"
  end

  test "edit should load a bookmark" do
    get :edit, :id => bookmarks(:google).id
    assert_equal bookmarks(:google), assigns(:bookmark)
    assert_response :success
    assert_template "bookmarks/edit"
  end

  test "update should change bookmark description and redirect to list page" do
    post :update, :id => bookmarks(:google).id, :bookmark => {
      :description => "Search Engine"
    }

    assert_equal bookmarks(:google), assigns(:bookmark)
    assert "Search Engine", bookmarks(:google, :reload).description
    assert_redirected_to bookmarks_url
  end

  test "update should render update template on invalid POST" do
    post :update, :id => bookmarks(:google).id, :bookmark => { :url => nil }
    assert_template "bookmarks/edit"
  end

  test "delete should remove bookmark" do
    assert_difference "Bookmark.count", -1 do
      delete :destroy, :id => bookmarks(:google).id
    end

    assert !Bookmark.exists?(bookmarks(:google).id)
    assert_redirected_to bookmarks_url
  end

  test "import should render page on GET" do
    get :import
    assert_response :success
    assert_template "bookmarks/import"
  end

  test "import should display error message when importing empty file" do
    assert_no_difference "Bookmark.count" do
      post :import, :file => nil
    end

    assert_equal "File cannot be empty!", flash[:error]
    assert_template "bookmarks/import"
  end

  test "import should create bookmarks in uploaded file" do
    assert_difference "users(:josh).bookmarks.count" do
      post :import, :file => File.open(File.join(Rails.root.to_s, "test/fixtures/bookmarks_to_import.html"), "r")
    end

    assert_equal "Bookmarks successfully imported!", flash[:notice]
    assert_redirected_to bookmarks_url
  end
end
