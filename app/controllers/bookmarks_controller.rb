class BookmarksController < ApplicationController
  before_filter :find_tags

  def index
    tag = params[:tag]
    @bookmarks = current_user.bookmarks
    @bookmarks = @bookmarks.tagged_with(tag) unless tag.blank?
    @bookmarks = @bookmarks.order("id desc")
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

  def import
    if request.post?
      file_data = params[:file]
      if file_data.blank?
        flash[:error] = "File cannot be empty!"
      else
        Bookmark.import(file_data, current_user.id)
        flash[:notice] = "Bookmarks successfully imported!"
        redirect_to bookmarks_url
      end
    end
  end

  private 

  def find_tags
    @tags = current_user.tags.sort_by(&:name)
  end
end
