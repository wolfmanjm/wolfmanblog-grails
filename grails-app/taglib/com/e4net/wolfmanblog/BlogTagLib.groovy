package com.e4net.wolfmanblog

class BlogTagLib {
	static namespace = "b"

	def renderHtml = {attrs, body ->
		// convert the <typo code> tags to use syntax Highlighter
		String s= body().replaceAll(/<typo:code\s+lang=\"(.*)\">/, "<script type='syntaxhighlighter' class='brush: \$1'><![CDATA[")
		s= s.replaceAll("</typo:code>", "]]></script>")

		def m = new com.petebevin.markdown.MarkdownProcessor();
		out << m.markdown(s);
	}

	// there are several ways to do this, but basically for comments I want to 
    // wrap long lines
    // preserve code
	// escape all tags
	// So convert any < or > to entities first
	// if the line starts with tab or 4 or more spaces then wrap in <pre> 
	def renderComment = {attrs, body ->
		def b=  body().toString().replaceAll('<', '&lt;').replaceAll('>', '&gt;')
		def inpre= false
		b.eachLine() {
			if(it =~ /(^\t|    ).*/) {
				if(inpre){
					out << it << '\n'
				}else{
					out << "<pre>\n" << it << '\n'
					inpre= true
				}
			}else {
				if(inpre) {
					out << "</pre>\n"
					inpre= false
				}
				out << it << '\n'
			}
		}
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
		if(session.user)
			out << body()
	}

	// preserve newlines and white space in body
	def preserve = {attrs, body ->
 		body().toString().eachLine {
			def ln= it
			out << ln.replaceAll(' ', '&nbsp;') + "<br />\n"
		}
	}

	def deleteButton = {attrs ->
		out << g.form(action: 'delete', id: "${attrs.id}", method: 'delete', name: 'delete', 'class': 'delete')
		out << g.actionSubmit(value: 'Delete', 'class': 'delete')
	}		                    

}
