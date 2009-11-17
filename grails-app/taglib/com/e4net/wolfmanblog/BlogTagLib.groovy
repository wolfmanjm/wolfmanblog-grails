package com.e4net.wolfmanblog

class BlogTagLib {
	static namespace = "blog"
		
	def renderHtml = { attrs, body ->
		def m = new com.petebevin.markdown.MarkdownProcessor();
		out <<  m.markdown(body().toString()); 
	}

	def permalink = { attrs, body ->
	    def post= attrs.post
		out << link(controller: 'post', action: 'show', params: [year: post.year, month: post.month, day: post.day, title: post.permalink], absolute: attrs.absolute){ body() }
	}

	def numComments = { attrs ->
        def n= attrs.post.comments.size()
        if(n > 0)
            out << link(controller: 'post', action: 'show', fragment: 'comments') {"${n} comments"} 
        else
            out << "no comments"
	}
	
    def categories = { attrs ->
        def l= []
        def a= attrs.post.categories
        a.each { i ->
            l << link(controller: "posts", action: "listByCategory"){ i.name }
        }
        out << l.join(',')
    }

    def tags = { attrs ->
		def l= []
	    def a= attrs.post.categories
	    a.each { i ->
	         l << link(controller: "posts", action: "listByTag"){ i.name }
	    }
	    out << l.join(',')
	}

		def isAuthenticated= {attrs, body ->
			out << body()
		}
}