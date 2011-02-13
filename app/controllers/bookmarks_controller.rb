class BookmarksController < ApplicationController
  before_filter :require_user
  before_filter :find_tags

  def index
    @bookmarks = current_user.bookmarks.order("id desc")

    if params[:tag]
      @bookmarks = @bookmarks.tagged_with(params[:tag])
    end

    @bookmarks = @bookmarks.paginate(
      :page => params[:page], 
      :per_page => Bookmark.per_page
    )

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @bookmark = Bookmark.new({
      :url => params[:url],
      :title => params[:title],
      :description => params[:description]
    })
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
    render :action => "new"
  end

  def edit
    @bookmark = current_user.bookmarks.find(params[:id])
  end

  def update
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.attributes = params[:bookmark]
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
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
    @tags = current_user.bookmarks.tag_counts.sort_by(&:name)
  end
end
