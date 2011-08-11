class BookmarksController < ApplicationController
  before_filter :require_user
  before_filter :store_location, only: %w(index search tagged starred)

  cattr_accessor :per_page
  @@per_page = 50

  def index
    @bookmarks = bookmarks.paginate(page: params[:page], per_page: @@per_page)
  end

  def search
    @bookmarks = Bookmark.search(params[:q], 
      with: { user_id: current_user.id },
      page: params[:page],
      per_page: @@per_page)

    render :index
  end
  
  def tagged
    @bookmarks = bookmarks
      .tagged_with(params[:id])
      .paginate(page: params[:page], per_page: @@per_page)

    render :index
  end

  def starred
    @bookmarks = bookmarks.starred.paginate(page: params[:page], per_page: @@per_page)
    render :index
  end

  def new
    @bookmark = Bookmark.new(
      url: params[:url],
      title: params[:title],
      description: params[:description])
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
    render :new
  end

  def edit
  end

  def update
    bookmark.attributes = params[:bookmark]
    bookmark.save!
    redirect_to bookmarks_url
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    bookmark.delete
    redirect_back_or_default bookmarks_url
  end

  def import
    return if request.get?

    if params[:file].blank?
      flash[:error] = "File cannot be empty!"
      return
    end

    begin
      Bookmark.import(params[:file], current_user.id)
      flash[:notice] = "Bookmarks successfully imported!"
      redirect_to bookmarks_url
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "File contains invalid bookmarks!"
    end
  end

  def toggle
    bookmark.toggle_starred
    bookmark.save!

    respond_to do |format|
      format.html { redirect_to bookmarks_url }
      format.js
    end
  end

  protected

  helper_method :bookmarks, :bookmark, :tags

  def bookmarks
    @bookmarks ||= current_user.bookmarks.order("id desc")
  end

  def tags
    @tags ||= current_user.bookmarks.tag_counts.sort_by(&:name)
  end

  def bookmark
    @bookmark ||= current_user.bookmarks.find(params[:id])
  end
end
