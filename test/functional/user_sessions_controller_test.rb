require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should GET :new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "should create user session" do
    post :create, :user_session => { :email => "joshorourke@me.com", :password => "secret123" }
    assert user_session = UserSession.find
    assert_equal users(:josh), user_session.user
    assert_redirected_to bookmarks_url
  end

  test "should destroy user session" do
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
end
