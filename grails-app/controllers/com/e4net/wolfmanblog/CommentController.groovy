package com.e4net.wolfmanblog

class CommentController {
	def scaffold = true
	def springcacheCacheManager

	// have these scaffolded actions clear the cache
	def afterInterceptor = [action:this.&clearCache, only:['delete', 'update']]

	// defined as a regular method so its private
	def clearCache(model) {
		log.debug "clearing cache as comment deleted"
		springcacheCacheManager.clearAll()
	}

	def rss = {
		render(contentType:"text/xml") {
			rss(version: "2.0", 'xmlns:dc': "http://purl.org/dc/elements/1.1/"){
				channel {
					title("Wolfmans Howlings") 
					link("http://blog.wolfman.com")
					description("A programmers Blog about Ruby, Rails and a few other issue")
					language("en-us")
					ttl("40")
					Comment.listOrderByDateCreated(order:"desc", max: 10).each() { comment ->
						item {
							title("${comment.post.title} by ${comment.name?.encodeAsHTML()}")
							pubDate(comment.dateCreated.encodeAsRfc822())
							link(createLink(controller: 'post', action: 'show',
							                params: [year: comment.post.year, month: comment.post.month, day: comment.post.day, id: comment.post.permalink],
							                absolute: true, fragment: "comment-${comment.id}"))
							guid("urn:uuid:${comment.guid}")
							description(comment.body?.encodeAsHTML())
						}
					}
				}
			}
		}
	}

}
