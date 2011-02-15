module BookmarksHelper
  def formatted_host(bookmark)
    if bookmark && bookmark.host
      "(#{bookmark.host})"
    end
  end

  def link_to_next_page
    if @bookmarks && @bookmarks.next_page
      next_page = params.merge(:page => @bookmarks.next_page)
      link_to "More", next_page, :remote => true, "data-type" => "script", :id => "next-page"
    end
  end
end
