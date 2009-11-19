package com.e4net.wolfmanblog

class PostController {
	def scaffold = true

	def index = { 
		def posts=  Post.list(max: 4, fetch: [tags: 'eager', categories: 'eager'])
		[posts: posts]
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
