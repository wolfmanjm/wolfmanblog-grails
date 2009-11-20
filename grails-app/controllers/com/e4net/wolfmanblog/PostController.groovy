package com.e4net.wolfmanblog

class PostController {
	def scaffold = true
	
	// TODO need to optimize so only comment count is fetched
	def index = { 
		params.putAll([fetch: [tags: 'eager', categories: 'eager', comments:'eager'], max: 4, sort: "dateCreated", order: "desc"])
		def posts=  Post.list(params)
		def postCount = Post.count()
		[posts: posts, postCount: postCount]
	}

	def show = {
		def post = Post.get(params.id)
		[post: post]
	}

	// Need to actually have show redirect to showByPermalink so nice permalink shows in browser bar
	def showByPermalink = {
		def post= Post.findByPermalink(params.id)
		redirect(action: 'show', id: post.id)
	}
}
