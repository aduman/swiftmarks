module ApplicationHelper
  def bookmarklet_url
    "javascript:(function() { " + 
    "var _script=document.createElement('SCRIPT');" +
    "_script.type='text/javascript';" +
    "_script.src='http://swiftmarksapp.com/javascripts/bookmarklet.js';" +
    "document.body.appendChild(_script);" +
    "})();"
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
