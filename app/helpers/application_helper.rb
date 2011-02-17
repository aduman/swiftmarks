module ApplicationHelper
  def bookmarklet_url
    "javascript:" +
    "document.location='#{new_bookmark_url(:only_path => false)}'+" + 
    "'?source=bookmarklet'+" +
    "'&url='+encodeURIComponent(location.href)+" +
    "'&title='+encodeURIComponent(document.title)"
  end

  def link_to_remote_script(*args, &block)
    if block_given?
      name         = capture(&block) 
      options      = args[0] || {}
      html_options = args[1] || {}
    else
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2] || {}
    end

    link_to(name, options, html_options.merge(options_for_remote_script))
  end

  def options_for_remote_script
    { :remote => true, "data-type" => "script" }
  end
end
