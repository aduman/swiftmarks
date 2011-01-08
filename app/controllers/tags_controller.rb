class TagsController < ApplicationController
  before_filter :require_user

  def index
    @tags = current_user.bookmarks.tag_counts

    respond_to do |format|
      format.json { render :json => @tags }
    end
  end
end
