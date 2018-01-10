$(function() {
  // fix rendering previews
  var simplemde;
  var preview = function(action) {
    action(simplemde);
    $(".editor-preview").addClass("content");
    $(".editor-preview-side").addClass("content");
  };

  simplemde = new SimpleMDE({
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
        action: function() { preview(SimpleMDE.togglePreview) },
        className: "fa fa-eye no-disable",
        title: "Toggle Preview"
      },
      {
        name: "side-by-side",
        action: function() { preview(SimpleMDE.toggleSideBySide) },
        className: "fa fa-columns no-disable no-mobile",
        title: "Toggle Side by Side"
      },
      "fullscreen", "|", "guide"
    ]
  });

  marked.setOptions({
    highlight: function(code) { return hljs.highlightAuto(code).value; },
    sanitize: true,
    smartypants: true
  });
  hljs.initHighlightingOnLoad();
});
