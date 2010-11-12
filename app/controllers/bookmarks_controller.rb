class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.all
  end

  def new
    @bookmark = Bookmark.new
    render "_form"
  end

  def create
    @bookmark = Bookmark.new(params[:bookmark])
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render "_form"
  end

  def edit
    @bookmark = Bookmark.find(params[:id])
    render "_form"
  end

  def update
    @bookmark = Bookmark.find(params[:id])
    @bookmark.attributes = params[:bookmark]
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActionRecord::RecordInvalid
    render "_form"
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.delete
    redirect_to bookmarks_url
  end
end
