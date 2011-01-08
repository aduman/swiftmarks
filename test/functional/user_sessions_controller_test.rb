require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "new should load a new UserSession and render page" do
    get :new
    assert assigns(:user_session).new_record?
    assert_response :success
    assert_template 'new'
  end

  test "create should sign in user and redirect to bookmarks list page" do
    post :create, :user_session => { :email => "joshorourke@me.com", :password => "secret123" }
    assert user_session = UserSession.find
    assert_equal users(:josh), user_session.user
    assert_redirected_to bookmarks_url
  end

  test "destroy should sign out user and redirect to sign in page" do
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
end
