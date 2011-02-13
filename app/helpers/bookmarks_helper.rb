module BookmarksHelper
  def bookmark_url_host(bookmark)
    if bookmark && bookmark.uri
      "(#{bookmark.uri.host})"
    else
      ""
    end
  end

  def next_page_link(parameters)
    if @bookmarks && @bookmarks.next_page
      next_page_url = parameters.merge(:page => @bookmarks.next_page)
      link_to "More", next_page_url, :id => "next-page"
    end
  end
end
