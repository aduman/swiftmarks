class BookmarksController < ApplicationController
  before_filter :require_user

  def index
    @tags      = find_tags
    @bookmarks = find_bookmarks
      .paginate(:page => params[:page], :per_page => Bookmark.per_page)
  end

  def search
    @tags      = find_tags
    @bookmarks = find_bookmarks
      .search(params[:q])
      .paginate(:page => params[:page], :per_page => Bookmark.per_page)

    render :action => "index"
  end
  
  def tagged
    @tags      = find_tags
    @bookmarks = find_bookmarks
      .tagged_with(params[:id])
      .paginate(:page => params[:page], :per_page => Bookmark.per_page)

    render :action => "index"
  end

  def starred
    @tags      = find_tags 
    @bookmarks = current_user.bookmarks.starred.order("id desc")
      .paginate(:page => params[:page], :per_page => Bookmark.per_page)

    render :action => "index"
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

    if params[:source] == "bookmarklet"
      redirect_to @bookmark.url
    else
      redirect_to bookmarks_url
    end
  rescue ActiveRecord::RecordInvalid
    render :action => "new"
  end

  def edit
    @bookmark = find_bookmark
  end

  def update
    @bookmark = find_bookmark
    @bookmark.attributes = params[:bookmark]
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
  end

  def destroy
    @bookmark = find_bookmark
    @bookmark.delete
    redirect_to bookmarks_url
  end

  def import
    if request.post?
      file_data = params[:file]
      if file_data.blank?
        flash[:error] = "File cannot be empty!"
      else
        begin
          Bookmark.import(file_data, current_user.id)
          flash[:notice] = "Bookmarks successfully imported!"
          redirect_to bookmarks_url
        rescue ActiveRecord::RecordInvalid
          flash[:error] = "File contains invalid bookmarks!"
        end
      end
    end
  end

  def toggle
    @bookmark = find_bookmark
    @bookmark.toggle_starred
    @bookmark.save!

    respond_to do |format|
      format.html { redirect_to bookmarks_url }
      format.js
    end
  end

  private

  def find_bookmarks
    current_user.bookmarks.order("id desc")
  end

  def find_bookmark
    current_user.bookmarks.find(params[:id])
  end

  def find_tags
    current_user.bookmarks.tag_counts.sort_by(&:name)
  end
end
