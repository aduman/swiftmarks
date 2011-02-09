require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "index should render index template with anonymous user" do
    get :index
    assert_response :success
    assert_template "index"
  end

  test "index should redirect to bookmarks_url with authenticated user" do
    UserSession.create(users(:josh))
    get :index
    assert_redirected_to bookmarks_url
  end
end
