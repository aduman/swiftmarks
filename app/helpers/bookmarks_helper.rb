module BookmarksHelper
  def tag_list_for(bookmark)
    if bookmark.cached_tag_list.blank?
      "Untagged"
    else
      bookmark.cached_tag_list
    end
  end

  def hostname_for(bookmark)
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
