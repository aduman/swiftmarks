require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:josh)
  end

  test "new should load user and render page" do
    get :new
    assert assigns(:user).new_record?
    assert_response :success
    assert_template "new"
  end

  test "create should create a user, set the flash, and redirect to account page on valid POST" do
    post :create, :user => { 
      :email => "johnny@swiftmarks.com", 
      :password => "secret123",
      :password_confirmation => "secret123"
    }

    assert_equal "Account registered!", flash[:notice]
    assert !assigns(:user).new_record?
    assert_redirected_to account_url
  end

  test "create should render new template on invalid POST" do
    post :create, :user => {}
    assert_template "new"
  end

  test "show should load user and render page" do
    UserSession.create(@user)
    get :show
    assert_equal users(:josh), assigns(:user)
    assert_response :success
    assert_template "show"
  end

  test "edit should load user and render page" do
    UserSession.create(@user)
    get :edit, :id => @user.id
    assert_equal users(:josh), assigns(:user)
    assert_response :success
    assert_template "edit"
  end

  test "update should change user, set the flash, and redirect to account page on valid POST" do
    UserSession.create(@user)
    post :update, :id => @user.id, :user => {}
    assert_equal "Account updated!", flash[:notice]
    assert_redirected_to account_url
  end

  test "update should render edit template on invalid POST" do
    UserSession.create(@user)
    post :update, :id => @user.id, :user => { :email => nil }
    assert_template "edit"
  end
end
