package com.e4net.wolfmanblog

class BlogController {

    def index = {
		def post= Post.list(max: 1)[0]
		[post: post]
	}

    def show = {
		def post= Post.list(max: 1)[0]
		[post: post]
	}
}
