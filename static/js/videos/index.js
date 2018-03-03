//Travis' Linkify modified, dunno exact source: https://stackoverflow.com/questions/37684/how-to-replace-plain-urls-with-links
if(!String.linkify) {
	String.prototype.linkify = function() {
		// http://, https://, ftp://
		var urlPattern = /\b(?:https?|ftp):\/\/[a-z0-9-+&@#\/%?=~_|!:,.;]*[a-z0-9-+&@#\/%=~_|]/gim;
		// www. sans http:// or https://
		var pseudoUrlPattern = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
		var emailAddressPattern = /\w+@[a-zA-Z_]+?(?:\.[a-zA-Z]{2,6})+/gim;
		return this
			.replace(urlPattern, '<a href="$&">$&</a>')
			.replace(pseudoUrlPattern, '$1<a href="https://$2">$2</a>')
			.replace(emailAddressPattern, '<a href="mailto:$&">$&</a>');
	};
}

var title, video, description; // element references

window.onload = function() {
  title = document.getElementById("title");
  video = document.getElementById("video");
  description = document.getElementById("description");

  description.innerHTML = description.innerHTML.linkify();
}

function v(id, titleText, descriptionText) {
  video.src = "https://www.youtube.com/embed/" + id;
  title.innerHTML = titleText;
  description.innerHTML = descriptionText.linkify();
}
