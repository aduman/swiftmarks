module ApplicationHelper
  def bookmarklet_url
    "javascript:" +
    "document.location='#{new_bookmark_url(:only_path => false)}'+" + 
    "'?source=bookmarklet'+" +
    "'&url='+encodeURIComponent(location.href)+" +
    "'&title='+encodeURIComponent(document.title)"
  end
end
