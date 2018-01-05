function slugify (str) {
  str = str.replace(/^\s+|\s+$/g, ''); // trim
  str = str.toLowerCase();

  // remove accents, swap ñ for n, etc
  var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
  var to   = "aaaaeeeeiiiioooouuuunc------";
  for (var i=0, l=from.length ; i<l ; i++) {
    str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
  }

  str = str.replace(/[^a-z0-9 -]/g, '') // remove invalid chars
    .replace(/\s+/g, '-') // collapse whitespace and replace by -
    .replace(/-+/g, '-'); // collapse dashes

  return str;
}

$(function() {
  // fix rendering previews
  var preview = function(action) {
    action();
    $(".editor-preview").addClass("content");
    $(".editor-preview-side").addClass("content");
  };

  var simplemde;
  simplemde = new SimpleMDE({
    // element: $("#text").get(0),
    // that doesn't work, but it attaches to the first
    //  textarea only by default, so it works
    autosave: {
      enabled: true,
      uniqueId: uniqueID
    },
    indentWithTabs: false,
    insertTexts: {
      link: ['[', '](https://)']
    },
    parsingConfig: {
      strikethrough: false
    },
    renderingConfig: {
      singleLineBreaks: false,
      codeSyntaxHighlighting: true // highlight.js by default
    },
    toolbar: [
      "bold", "italic", "strikethrough", "heading", "|", "quote",
      "unordered-list", "ordered-list", "|", "link", "image", "|",
      {
        name: "preview",
        action: function() { preview(simplemde.togglePreview) },
        className: "fa fa-eye no-disable",
        title: "Toggle Preview",
        // default: true
      },
      {
        name: "side-by-side",
        action: function() { preview(simplemde.toggleSideBySide) },
        className: "fa fa-columns no-disable no-mobile",
        title: "Toggle Side by Side",
        // default: true
      },
      "fullscreen", "|", "guide"
    ]
  });

  marked.setOptions({
    highlight: function(code) { return hljs.highlightAuto(code).value; },
    // sanitize: true, // NOTE only disabled for admins!
    smartypants: true
  });
  hljs.initHighlightingOnLoad();

  var title = $('#title');
  var preview_text = $('#preview_text').get(0);
  var _html = $('#html');
  var preview_html = $('#preview_html');

  title.on('input', function() {
    var slug = $('#slug').get(0);
    var val = title.val();
    if (val == "") {
      slug.placeholder = "title";
    } else {
      slug.placeholder = slugify(val);
    }
  });

  simplemde.codemirror.on('change', function() {
    preview_text.placeholder = simplemde.value().substring(0, 500);
    _html.val(marked(simplemde.value()));

    if (preview_text.value != "") {
      preview_html.val(marked(preview_text.value));
    } else {
      preview_html.val(marked(preview_text.placeholder));
    }
  });

  var ptype = $('#type');
  var status = $('#status');

  ptype.on('change', function() {
    var splat = $('#splat');
    if (ptype.val() == 9) { // hardcoded :\
      splat.removeClass('is-invisible');
    } else {
      splat.addClass('is-invisible');
      splat.val("");
    }
  });

  status.on('change', function() {
    var published_at = $('#published_at');
    if (status.val() == 3) { // hardcoded :\
      published_at.removeClass('is-invisible');
    } else {
      published_at.addClass('is-invisible');
      published_at.val("");
    }
  })
});
