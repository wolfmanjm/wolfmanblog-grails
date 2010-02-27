package com.e4net.wolfmanblog

import grails.plugin.springcache.annotations.Cacheable
import grails.plugin.springcache.annotations.CacheFlush

class PostController {
	def defaultAction = 'index'
	
	static allowedMethods = [save: "POST", update: "POST", upload: "POST", delete: ["POST", "DELETE"], addComment: "POST" ]
	
	def scaffold = true
	def blogService

	@Cacheable(modelId = "PostController")
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
	
	@Cacheable(modelId = "PostController")
	def show = {
		def post= Post.findByPermalink(params.id)
		if(!post){
			flash.message = "Post not found"
			redirect(action:index)			
		}else
			[post: post]
	}
	
	def listByTag = {
		// don't allow more than 10 to show default to 4, even if asked by request
		params.max = Math.min(params.max ? params.max.toInteger() : 4, 10)
		
		def posts= Post.executeQuery("select p from Post p join p.tags as t where t.name = ?", [params.id], params)
		def postCount = Post.executeQuery("select count(p.id) from Post p join p.tags as t where t.name = ?", [params.id]).first()
		render(view: 'index', model: [posts: posts, postCount: postCount])
	}
	
	def listByCategory = {	
		// don't allow more than 10 to show default to 4, even if asked by request
		params.max = Math.min(params.max ? params.max.toInteger() : 4, 10)

		def posts= Post.executeQuery("select p from Post p join p.categories as c where c.name = ?", [params.id], params)
		def postCount = Post.executeQuery("select count(p.id) from Post p join p.categories as c where c.name = ?", [params.id]).first()
		render(view: 'index', model: [posts: posts, postCount: postCount])
	}
	
	@CacheFlush(modelId = "PostController")
	def addComment = {
		log.debug "add comment: ${params}"
		def id= params.id
		if(!blogService.addComment(params)){
			flash.message= "Failed to post comment"
			redirect(action: 'showById', id: id)
		}else
			redirect(action: 'showById', id: id, fragment: "comments")
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
					Post.list(max: 4).each() { article ->
						item {
							title(article.title)
							author("Jim Morris")
							pubDate(article.dateCreated.encodeAsRfc822())
							link(createLink(controller: 'post', action: 'show',
							                params: [year: article.year, month: article.month, day: article.day, id: article.permalink],
							                absolute: true))
							guid("urn:uuid:${article.guid}")
							description(b.renderHtml(){ article.body })
						}
					}
				}
			}
		}
	}
	
	// Note this may be access by id or permalink
	def showRss = {
		def post
		if(params.id =~ /^\d+$/)
			post=  Post.get(params.id)
		else
			post=  Post.findByPermalink(params.id)
		

		if(! post){
			render(status: 400, text: "article not found")
			return
		}
		
		def url= createLink(controller: 'post', action: 'show',
		                    params: [year: post.year, month: post.month, day: post.day, id: post.permalink],
		                    absolute: true)
		
		render(contentType:"text/xml") {
			rss(version: "2.0", 'xmlns:dc': "http://purl.org/dc/elements/1.1/"){
				channel {
					title("Wolfmans Howlings: ${post.title}") 
					link(url)
					description("A programmers Blog about Ruby, Rails and a few other issue")
					language("en-us")
					ttl("40")
					item {
						title(post.title)
						author("Jim Morris")
						pubDate(post.lastUpdated.encodeAsRfc822())
						link(url)
						guid("urn:uuid:${post.guid}")
						description(b.renderHtml(){ post.body })
					}
					post.comments.each { comment ->
						item {
							title("Comment by ${comment.name?.encodeAsHTML()}")
							description(comment.body?.encodeAsHTML())
							pubDate(comment.dateCreated.encodeAsRfc822())
							link("${url}#comment-#{comment.id}")
							guid("urn:uuid:${comment.guid}")
						}
					}
				}
			}
		}
	}
	
	@CacheFlush(modelId = "All")
	def upload = {		
		try {
			blogService.createOrUpdatePost(request)
			log.info "Uploaded Post"
			render(status: 200, text: "uploaded post ok")
		}catch(MyPostException ex){
			log.error "Failed to upload", ex
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
	
	@CacheFlush(modelId = "All")
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
	
	@CacheFlush(modelId = "All")
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
	
	@CacheFlush(modelId = "All")
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
