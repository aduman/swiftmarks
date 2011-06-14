class BookmarksController < ApplicationController
  before_filter :require_user
  before_filter :find_tags, :only => [:index, :starred]
  before_filter :find_bookmark, :only => %w(edit update destroy toggle)

  def index
    find_bookmarks
  end

  def starred
    find_starred_bookmarks
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
  end

  def update
    @bookmark.attributes = params[:bookmark]
    @bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
  end

  def destroy
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
    @bookmark.toggle_starred
    @bookmark.save!

    respond_to do |format|
      format.html { redirect_to bookmarks_url }
      format.js
    end
  end

  protected 

  helper_method :paginating?

  def paginating?
    params[:page].to_i > 1
  end

  private

  def find_bookmarks
    @bookmarks = current_user.bookmarks.order("id desc")

    if params[:search]
      @bookmarks = @bookmarks.search(params[:search])
    elsif params[:tag]
      @bookmarks = @bookmarks.tagged_with(params[:tag])
    end

    paginate!
  end

  def find_starred_bookmarks
    @bookmarks = current_user.bookmarks.starred.order("id desc")
    paginate!
  end

  def find_bookmark
    @bookmark = current_user.bookmarks.find(params[:id])
  end

  def find_tags
    @tags = current_user.bookmarks.tag_counts.sort_by(&:name)
  end

  def paginate!
    @bookmarks = @bookmarks.paginate(
      :page     => params[:page],
      :per_page => Bookmark.per_page
    )
  end
end
