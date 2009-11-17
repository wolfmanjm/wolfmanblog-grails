package com.e4net.wolfmanblog

class PostController {
	def scaffold = true
	def index = { 
		def posts=  Post.list(max: 4, fetch: [tags: 'eager', categories: 'eager'])
		[posts: posts]
	}
}
