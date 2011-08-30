$(function() {
  var availableTags = [];

  function extractLast( term ) {
    return split( term ).pop();
  }

  function split( val ) {
    return val.split( /,\s*/ );
  }

  $.getJSON("/tags.json", function(data) {
    $(data).each(function(index, item) {
      availableTags.push(item.tag.name);
    });
  });

  $("#bookmark_tag_list")
    // don't navigate away from the field on tab when selecting an item
    .bind( "keydown", function( event ) {
      if ( event.keyCode === $.ui.keyCode.TAB &&
          $( this ).data( "autocomplete" ).menu.active ) {
        event.preventDefault();
      }
    })
    .autocomplete({
      minLength: 0,
      source: function( request, response ) {
        // delegate back to autocomplete, but extract the last term
        response( $.ui.autocomplete.filter(
          availableTags, extractLast( request.term ) ) );
      },
      focus: function() {
        // prevent value inserted on focus
        return false;
      },
      select: function( event, ui ) {
        var terms = split( this.value );
        // remove the current input
        terms.pop();
        // add the selected item
        terms.push( ui.item.value );
        // add placeholder to get the comma-and-space at the end
        terms.push( "" );
        this.value = terms.join( ", " );
        return false;
      }
    });
});
