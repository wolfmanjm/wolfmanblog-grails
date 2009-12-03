package com.e4net.wolfmanblog

class PostController {
	def defaultAction = 'index'
	
	static allowedMethods = [save: "POST", update: "POST", upload: "POST", delete: ["POST", "DELETE"] ]

	def scaffold = true

	def blogService

	// only allow the following if not logged in
	def beforeInterceptor = [action:this.&auth, except:['index', 'showById', 'listByCategory', 'listByTag', 'show', 'atom']]
	
	// defined as a regular method so its private
	def auth() {
		if(!session.user) {
			redirect(controller: 'user', action: 'login')
			return false
		}
	}
	
	def index = {
		// don't allow more than 10 to show, even if asked by request
		params.max = Math.min(params.max ? params.max.toInteger() : 4, 10)
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

	def upload = {
		try {
			blogService.createOrUpdatePost(request)
			render(status: 200, text: "uploaded post ok")
		}catch(MyPostException ex){
			render(status: 406, text: ex.message)
		}
	}

	// scaffold generated, only used by admin
	def list = {
		params.max = Math.min(params.max ? params.max.toInteger() : 10, 100)
		[postInstanceList: Post.list(params), postInstanceTotal: Post.count()]
	}

	def create = {
		def postInstance = new Post()
		postInstance.properties = params
		return [postInstance: postInstance]
	}

	def save = {
		def postInstance = new Post(params)
		try {
			if (postInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.created.message', args: [message(code: 'post.label', default: 'Post'), postInstance.id])}"
				redirect(action: "show", id: postInstance.id)
			} else {
				render(view: "create", model: [postInstance: postInstance])
			}
		} catch (org.springframework.dao.DataIntegrityViolationException ex) {
			flash.message = "Error not unique title: ${ex.message}"
			render(view: "create", model: [postInstance: postInstance])
		} 
	}

	def edit = {
		def postInstance = Post.get(params.id)
		if (!postInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'post.label', default: 'Post'), params.id])}"
			redirect(action: "list")
		}
		else {
			return [postInstance: postInstance]
		}
	}

	def update = {
		def postInstance = Post.get(params.id)
		if (postInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (postInstance.version > version) {
					
					postInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'post.label', default: 'Post')] as Object[], "Another user has updated this Post while you were editing")
					render(view: "edit", model: [postInstance: postInstance])
					return
				}
			}
			postInstance.properties = params
			if (!postInstance.hasErrors() && postInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'post.label', default: 'Post'), postInstance.id])}"
				redirect(action: "show", id: postInstance.id)
			}
			else {
				render(view: "edit", model: [postInstance: postInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'post.label', default: 'Post'), params.id])}"
			redirect(action: "list")
		}
	}

	def delete = {
		def postInstance = Post.get(params.id)
		if (postInstance) {
			try {
				postInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'post.label', default: 'Post'), params.id])}"
				redirect(action: "list")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'post.label', default: 'Post'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'post.label', default: 'Post'), params.id])}"
			redirect(action: "list")
		}
	}
}
