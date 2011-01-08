require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @user = users(:josh)
    create_bookmark
    UserSession.create(@user)
  end

  test "index should return a user's tag and render json" do
    get :index, :format => :json
    expected = @user.bookmarks.tag_counts_on(:tags)
    assert_response :success
    assert_equal expected.to_json, @response.body
  end

  private

  def create_bookmark
    Bookmark.create({
      :url => "http://www.yahoo.com",
      :title => "Yahoo",
      :tag_list => "search",
      :user_id => @user.id
    })
  end
end
