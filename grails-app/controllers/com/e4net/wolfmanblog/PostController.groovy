package com.e4net.wolfmanblog

class PostController {
	def defaultAction = 'index'
	def scaffold = true

	static allowedMethods = [upload: "POST", delete: ["POST", "DELETE"] ]

	// only allow the following if not logged in
	def beforeInterceptor = [action:this.&auth, except:['index', 'showById', 'listByCategory', 'listByTag', 'show', 'atom']]
	
	// defined as a regular method so its private
	def auth() {
		if(!session.user) {
			redirect(controller: 'user', action: 'login')
			return false
		}
	}
	
	// TODO need to optimize so only comment count is fetched
	def index = { 
		params.putAll([fetch: [tags: 'eager', categories: 'eager', comments:'eager'], max: 4])
		def posts=  Post.list(params)
		def postCount = Post.count()
		[posts: posts, postCount: postCount]
	}

	// redirect to showByPermalink so nice permalink shows in browser bar
	def showById = {
		def id= params.id
		if(id =~ /^\d+$/){
			def post = Post.get(params.id)
			if(!post) {
				flash.message = "Post not found"
				redirect(action:index)
			}else
				redirect(action: 'show', params: [year: post.year, month: post.month, day: post.day, id: post.permalink])
		}else
			render(status: 404, text: "invalid id")
	}

	def show = {
		def post= Post.findByPermalink(params.id)
		if(!post){
			flash.message = "Post not found"
			redirect(action:index)			
		}else
			[post: post]
	}
	
	def listByTag = {
		def query = {
			tags {
				eq('name', params.id)
			}
			//order("dateCreated", "asc")
		}
		params.max= params.max ?: 4 
		def posts = Post.createCriteria().list(params, query)
		def postCount = Post.createCriteria().count(query)
		render(view: 'index', model: [posts: posts, postCount: postCount])
	}

	def atom = {
		if(!params.max) params.max = 10
		def list = Post.list( params )
		def lastUpdated = list[0].lastUpdated
		[ posts:list, lastUpdated:lastUpdated ]
	}

}
