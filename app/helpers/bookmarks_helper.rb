module BookmarksHelper
  def bookmark_url_host(bookmark)
    if bookmark && bookmark.uri
      "(#{bookmark.uri.host})"
    else
      ""
    end
  end
end
