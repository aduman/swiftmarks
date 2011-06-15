require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase
  setup do
    UserSession.create(users(:josh))
    Bookmark.per_page = 1
  end

  test "index should return a paged set of bookmarks for current user" do
    get :index
    assert_equal 1, assigns(:bookmarks).size
    assert_equal users(:josh).id, assigns(:bookmarks).first.user_id
    assert_response :success
    assert_template "bookmarks/index"
  end

  test "tagged should return a paged set of bookmarks by tag for current user" do
    get :tagged, :id => "shopping"
    assert_equal 1, assigns(:bookmarks).size
    assert_equal %w(Amazon), assigns(:bookmarks).map(&:title)
    assert_equal %w(search shopping), assigns(:tags).map(&:name)
    assert_response :success
    assert_template "bookmarks/index"
  end

  test "starred should return a paged set of starred bookmarks for current user" do
    get :starred
    assert_equal 1, assigns(:bookmarks).size
    assert assigns(:bookmarks).all? { |b| b.starred? }
    assert_equal users(:josh).id, assigns(:bookmarks).first.user_id
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
      post :import, :file => File.open("test/fixtures/valid_bookmarks_to_import.html")
    end

    assert_equal "Bookmarks successfully imported!", flash[:notice]
    assert_redirected_to bookmarks_url
  end

  test "import should display an error when importing file with invalid bookmarks" do
    assert_no_difference "users(:josh).bookmarks.count" do
      post :import, :file => File.open("test/fixtures/invalid_bookmarks_to_import.html")
    end

    assert_equal "File contains invalid bookmarks!", flash[:error]
    assert_template "bookmarks/import"
  end

  test "toggle should respond with js format" do
    put :toggle, :id => bookmarks(:unstarred).id, :format => 'js'
    assert_equal Mime::JS, response.content_type
    assert_response :success
    assert_template "bookmarks/toggle"
  end

  test "toggle should mark an unstarred bookmark as starred" do
    put :toggle, :id => bookmarks(:unstarred).id        
    assert assigns(:bookmark).starred?
    assert_redirected_to bookmarks_url
  end

  test "toggle should mark a starred bookmark as unstarred" do
    put :toggle, :id => bookmarks(:starred).id
    assert !assigns(:bookmark).starred?
    assert_redirected_to bookmarks_url
  end
end
