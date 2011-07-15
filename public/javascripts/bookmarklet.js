(function() {
    // GLOBALS

    var iframeName = 'swiftmarks_frame';
    var formTitle  = 'Swiftmarks: Add Bookmark';
    var formAction = 'http://swiftmarksapp.com/bookmarks';


    // FUNCTIONS

    var closeFrameHandler = function(e) {
      preventDefault(e);
      closeFrame();
    }

    var submitFormHandler = function(e) {
      preventDefault(e);
      currentTarget(e).submit();
      setTimeout(closeFrame, 350);
    }

    var closeFrame = function() {
      iframe.parentNode.removeChild(iframe);
    }

    var preventDefault = function(e) {
      var evt = e || iframe.contentWindow.event;

      if (evt.preventDefault) {
        evt.preventDefault();
      }

      evt.returnValue = false;
    }
    
    var currentTarget = function(e) {
      var evt = e || iframe.contentWindow.event;
      return (evt.target) ? evt.target : evt.srcElement;
    }

    // CREATE IFRAME

    var iframe  = document.createElement('iframe');
    iframe.id = iframeName;
    iframe.name = iframeName;
    iframe.style.zIndex = 2147483647;
    iframe.style.position = 'fixed';
    iframe.style.left = '10px';
    iframe.style.top = '10px';
    iframe.style.width = '425px';
    iframe.style.height = '325px';
    iframe.style.border = 'solid 3px #AAA';

    document.body.appendChild(iframe);

    // IFRAME - DOCUMENT

    var frameDocument;

    if (iframe.contentDocument) {
      frameDocument = iframe.contentDocument;
    }
    else if (iframe.contentWindow) {
      frameDocument = iframe.contentWindow.document;
    }
    else {
      frameDocument = window.frames[iframeName].document; 
    }

    frameDocument.open();
    frameDocument.close();

    
    // IFRAME - BODY

    var frameBody = frameDocument.body;
    frameBody.style.backgroundColor = '#FFF';
    frameBody.style.color = '#555';
    frameBody.style.fontFamily = 'Arial, sans-serif';
    frameBody.style.fontSize = '16px';
    frameBody.style.margin = '10px';


    // IFRAME - H1

    var h1 = frameDocument.createElement('h1');
    h1.style.fontSize = '18px';
    h1.innerHTML = formTitle;
    

    // IFRAME - FORM

    var form = frameDocument.createElement('form');
    form.action = formAction;
    form.method = 'post';
    form.onsubmit = submitFormHandler;


    // IFRAME - FIELDSET 1

    var fieldset1 = frameDocument.createElement('p');

    var urlLabel = frameDocument.createElement('label');
    urlLabel.setAttribute('for', 'bookmark_url');
    urlLabel.innerHTML = 'URL'

    var urlField = frameDocument.createElement('input');
    urlField.id = 'bookmark_url';
    urlField.name = 'bookmark[url]';
    urlField.type = 'text';
    urlField.value = window.parent.location.href;
    urlField.style.fontSize = '16px';
    urlField.style.overflow = 'visible';
    urlField.style.padding = '5px';
    urlField.style.width = '95%';


    // IFRAME - FIELDSET 2 

    var fieldset2 = frameDocument.createElement('p');

    var titleLabel = frameDocument.createElement('label');
    titleLabel.setAttribute('for', 'bookmark_title');
    titleLabel.innerHTML = 'Title';

    var titleField = frameDocument.createElement('input');
    titleField.id = 'bookmark_title';
    titleField.name = 'bookmark[title]';
    titleField.type = 'text';
    titleField.value = window.parent.document.title;
    titleField.style.fontSize = '16px';
    titleField.style.overflow = 'visible';
    titleField.style.padding = '5px';
    titleField.style.width = '95%';


    // IFRAME - FIELDSET 3

    var fieldset3 = frameDocument.createElement('p');

    var tagLabel = frameDocument.createElement('label');
    tagLabel.setAttribute('for', 'bookmark_tag_list');
    tagLabel.innerHTML = 'Tags';

    var tagField = frameDocument.createElement('input');
    tagField.id = 'bookmark_tag_list';
    tagField.name = 'bookmark[tag_list]';
    tagField.type = 'text';
    tagField.style.fontSize = '16px';
    tagField.style.overflow = 'visible';
    tagField.style.padding = '5px';
    tagField.style.width = '95%';


    // IFRAME - FIELDSET 4

    var fieldset4 = frameDocument.createElement('p');

    var createButton = frameDocument.createElement('input');
    createButton.type = 'submit';
    createButton.value = 'Create';

    var cancelButton = frameDocument.createElement('input');
    cancelButton.type = 'submit';
    cancelButton.value = 'Cancel';
    cancelButton.onclick = closeFrameHandler;


    // APPEND ELEMENTS TO IFRAME

    fieldset1.appendChild(urlLabel);
    fieldset1.appendChild(urlField);
    fieldset2.appendChild(titleLabel);
    fieldset2.appendChild(titleField);
    fieldset3.appendChild(tagLabel);
    fieldset3.appendChild(tagField);
    fieldset4.appendChild(createButton);
    fieldset4.appendChild(cancelButton);

    form.appendChild(fieldset1);
    form.appendChild(fieldset2);
    form.appendChild(fieldset3);
    form.appendChild(fieldset4);

    var fragment = frameDocument.createDocumentFragment();
    fragment.appendChild(h1);
    fragment.appendChild(form);
    frameBody.appendChild(fragment);
}());
