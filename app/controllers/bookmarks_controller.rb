class BookmarksController < ApplicationController
  before_filter :find_tags

  def index
    if (params[:tag])
      @bookmarks = current_user.bookmarks.tagged_with(params[:tag])
    else
      @bookmarks = current_user.bookmarks.all
    end
  end

  def new
    @bookmark = Bookmark.new({
      :url => params[:url],
      :title => params[:title],
      :description => params[:description]
    })

    render "_form"
  end

  def create
    @bookmark = current_user.bookmarks.new(params[:bookmark])
    @bookmark.save!

    if (params[:source] == "bookmarklet")
      redirect_to @bookmark.url
    else
      redirect_to bookmarks_url
    end
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

  private 

  def find_tags
    @tags = current_user.bookmarks.tag_counts_on(:tags).sort_by(&:name)
  end
end
