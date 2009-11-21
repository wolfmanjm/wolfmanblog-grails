package com.e4net.wolfmanblog

class BlogTagLib {
	static namespace = "blog"

	def renderHtml = {attrs, body ->
		def m = new com.petebevin.markdown.MarkdownProcessor();
		out << m.markdown(body().toString());
	}

	def permalink = {attrs, body ->
		def post = attrs.post
		out << link(controller: 'post', action: 'show', params: [year: post.year, month: post.month, day: post.day, id: post.permalink], absolute: attrs.absolute) { body() }
	}

	def numComments = {attrs ->
		def n = attrs.post.comments.size()
		if (n > 0)
			out << link(controller: 'post', action: 'show', id: attrs.post.id, fragment: 'comments') {"${n} comments"}
		else
			out << "no comments"
	}

	def categories = {attrs ->
		def l = []
		def a = attrs.post.categories
		a.each {i ->
			l << link(controller: "post", action: "listByCategory", id: i.name) { i.name }
		}
		out << l.join(',')
	}

	def tags = {attrs ->
		def l = []
		def a = attrs.post.tags
		a.each {i ->
			l << link(controller: "post", action: "listByTag", id: i.name) { i.name }
		}
		out << l.join(',')
	}

	def isAuthenticated = {attrs, body ->
		if(false)
			out << body()
	}

	// preserve newlines and white space in body
	def preserve = {attrs, body ->
		body().toString().eachLine {
			def ln= it
			out << ln.replaceAll(' ', '&nbsp;') + "<br />\n"
		}
	}

}
