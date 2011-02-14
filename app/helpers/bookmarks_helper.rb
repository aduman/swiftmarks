module BookmarksHelper
  def formatted_host(bookmark)
    if bookmark && bookmark.host
      "(#{bookmark.host})"
    end
  end

  def next_page_link(parameters)
    if @bookmarks && @bookmarks.next_page
      next_page_url = parameters.merge(:page => @bookmarks.next_page)
      link_to "More", next_page_url, :remote => true, "data-type" => "script", :id => "next-page"
    end
  end
end
