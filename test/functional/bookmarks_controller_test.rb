require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase
  setup do
    @user = users(:josh)
    @bookmark = bookmarks(:google)
    UserSession.create(@user)
  end

  test "index should return a paged set of bookmarks for current user" do
    Bookmark.per_page = 1
    get :index
    assert_equal 1, assigns(:bookmarks).count
    assert_response :success
    assert_template "index"
  end

  test "new should render template new" do
    get :new
    assert_response :success
    assert_template "bookmarks/new"
  end

  test "create should create a bookmark and redirect to the list page" do
    post :create, :bookmark => {
      :url => "http://www.yahoo.com",
      :title => "Yahoo",
      :description => "Yahoo Search Engine"
    }

    assert !assigns(:bookmark).new_record?
    assert_redirected_to bookmarks_url
  end

  test "create should render new template on invalid POST" do
    post :create, :bookmark => {}
    assert_template "bookmarks/new"
  end

  test "edit should load a bookmark" do
    get :edit, :id => @bookmark.id
    assert_response :success
    assert_template "bookmarks/edit"
  end

  test "update should change bookmark description and redirect to list page" do
    post :update, :id => @bookmark.id, :bookmark => {
      :description => "Search Engine"
    }

    assert "Search Engine", assigns(:bookmark).description
    assert_redirected_to bookmarks_url
  end

  test "update should render update template on invalid POST" do
    post :update, :id => @bookmark.id, :bookmark => { :url => nil }
    assert_template "bookmarks/edit"
  end

  test "delete should remove bookmark" do
    delete :destroy, :id => @bookmark.id
    assert !Bookmark.exists?(@bookmark.id)
    assert_redirected_to bookmarks_url
  end

  test "import should render page on GET" do
    get :import
    assert_response :success
    assert_template "bookmarks/import"
  end

  test "import should display error message when importing empty file" do
    post :import, :file => nil
    assert_equal "File cannot be empty!", flash[:error]
    assert_template "bookmarks/import"
  end

  test "import should create bookmarks in uploaded file" do
    post :import, :file => File.open(File.join(Rails.root.to_s, "test/fixtures/bookmarks_to_import.html"), "r")
    assert_equal "Bookmarks successfully imported!", flash[:notice]
    assert Bookmark.where(:title => "Yahoo").count > 0
    assert_redirected_to bookmarks_url
  end
end
