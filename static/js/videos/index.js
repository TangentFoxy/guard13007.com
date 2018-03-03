//Travis' Linkify modified, dunno exact source: https://stackoverflow.com/questions/37684/how-to-replace-plain-urls-with-links
if(!String.linkify) {
	String.prototype.linkify = function() {
		// http://, https://, ftp://
		let urlPattern = /\b(?:https?|ftp):\/\/[a-z0-9-+&@#\/%?=~_|!:,.;]*[a-z0-9-+&@#\/%=~_|]/gim;
		// www. sans http:// or https://
		let pseudoUrlPattern = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
		let emailAddressPattern = /\w+@[a-zA-Z_]+?(?:\.[a-zA-Z]{2,6})+/gim;
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

  description.innerHTML = description.innerHTML.linkify().replace(/(?:\r\n|\r|\n)/g, '<br />');

  images = document.getElementsByTagName("img");
  for (i in images) {
    let image = images[i];
    if (Math.abs(image.width/image.height - 1.33) < 0.01) {
      // wrong resolution
      image.parentElement.parentElement.setAttribute("style", "overflow:hidden;");
      image.setAttribute("style", "margin-top:-9.32%;margin-bottom:-9.32%;");
    }
  }
}

function v(id, titleText, descriptionText) {
  video.src = "https://www.youtube.com/embed/" + id;
  title.innerHTML = titleText;
  description.innerHTML = descriptionText.linkify().replace(/(?:\r\n|\r|\n)/g, '<br />');

	window.scrollTo(0, 0); // go to top
}
