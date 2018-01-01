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
  var simplemde = new SimpleMDE({
    autosave: {
      enabled: true,
      uniqueId: '/post/new'
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
    }
  });

  var title = $('#title');
  var type = $('#type');
  var status = $('#status');

  title.on('input', function() {
    $('#slug').get(0).placeholder = slugify(title.get(0).value);
  });

  // TODO type changed ->
  //  if set to stand_alone, remove 'is-invisible' from #splat
  //  else add 'is-invisible' and clear its value!
  // TODO status changed ->
  //  if set to scheduled, remove 'is-invisible' from #published_at
  //  else add `is-invisible` and clear its value!
});
