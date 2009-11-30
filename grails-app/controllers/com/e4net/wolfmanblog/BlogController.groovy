package com.e4net.wolfmanblog

class BlogController {

	def blogService

    def index = {
		def post= Post.list(max: 1)[0]
		[post: post]
	}

    def show = {
		def post= Post.list(max: 1)[0]
		[post: post]
	}

	def categories = {
		def m= blogService.getCategories()
		render(text: m.toString())
	}

	def test = {
		def res= blogService.testRawSql();
		render(text: res)
	}
}
