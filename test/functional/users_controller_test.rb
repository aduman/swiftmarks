require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:josh)
  end

  test "on GET to :new" do
    get :new
    assert_response :success
    assert_template "new"
  end

  test "on valid POST to :create" do
    post :create, :user => { 
      :email => "johnny@swiftmarks.com", 
      :password => "secret123",
      :password_confirmation => "secret123"
    }

    assert_equal "Account registered!", flash[:notice]
    assert_redirected_to account_url
  end

  test "on invalid POST to :create" do
    post :create, :user => {}
    assert_template "new"
  end

  test "on GET to :show" do
    UserSession.create(@user)
    get :show
    assert_response :success
    assert_template "show"
  end

  test "on GET to :edit" do
    UserSession.create(@user)
    get :edit, :id => @user.id
    assert_response :success
    assert_template "edit"
  end

  test "on valid POST to :update" do
    UserSession.create(@user)
    post :update, :id => @user.id, :user => {}

    assigns(:user).errors.each { |e,m| puts "#{e} - #{m}" }

    assert_equal "Account updated!", flash[:notice]
    assert_redirected_to account_url
  end

  test "on invalid POST to :update" do
    UserSession.create(@user)
    post :update, :id => @user.id, :user => { :email => nil }
    assert_template "edit"
  end
end
