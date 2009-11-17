package com.e4net.wolfmanblog

class BlogController {

    def index = {
		def post= Post.get(1)
		[post: post]
	}
}
