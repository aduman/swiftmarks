class BookmarksController < ApplicationController
  def index
    @bookmarks = current_user.bookmarks.all
  end

  def new
    @bookmark = Bookmark.new
    render "_form"
  end

  def create
    @bookmark = current_user.bookmarks.new(params[:bookmark])
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render "_form"
  end

  def edit
    @bookmark = current_user.bookmarks.find(params[:id])
    render "_form"
  end

  def update
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.attributes = params[:bookmark]
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render "_form"
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.delete
    redirect_to bookmarks_url
  end
end
