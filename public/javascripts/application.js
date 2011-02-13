// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader("Accept", "text/javascript") }
})

$(document).ready(function() {
  // Pagination button for bookmarks#index
  $("#pagination a#next-page").live("click", function() {  
    var url = $(this).attr("href");
    $.get(url, { format: "js" });
    return false;
  });
})
