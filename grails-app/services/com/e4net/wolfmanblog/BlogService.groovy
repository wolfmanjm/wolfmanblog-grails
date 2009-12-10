package com.e4net.wolfmanblog

import org.jvyaml.YAML
import org.hibernate.Hibernate

class BlogService {
	
	boolean transactional = true
	
	def createNewUser(params) {
		def userInstance = new User(params)
		def ok
		try {
			ok= userInstance.save(flush: true)
		} catch (org.springframework.dao.DataIntegrityViolationException ex) {
			log.warn("Data Integrity Exception", ex)
			throw new MyUserException(message: "Username must be Unique", user: userInstance)
		}
		if(!ok){
			throw new MyUserException(message: "", user: userInstance)
		}
		return userInstance
	}
	
	def addComment(params) {
		if(!params.test.equalsIgnoreCase("no")){
			log.debug "spambot test failed"
			return false
		}

	    def post= Post.get(params.id)
	    if(post) {
			log.debug "Adding comment: ${params}"
			params.remove('id')
			def comment= new Comment(params)
			// We do it this way round so that we don't have to fetch all the comments
			// and post doesn't not get updated
			comment.post= post
			comment.save()
			return true
		}else{
			log.debug "Failed to add comment"
			return false
		}
	}
	
	def createOrUpdatePost(request) {
		def h
		try {
			h= parseUpload(request.getReader())
		} catch (Exception ex) {
			log.error("Failed to parse YAML: ${ex.message}", ex)
			throw new MyPostException(message: "Failed to parse post")
		}
		
		def post= Post.findByTitle(h.title)
		if(!post) {
			post= new Post(title: h.title, body: h.body)
		}else{
			post.body= h.body
		}
		
		try {
			// add any new categories and remove any not specified
			def cats= post.categories
			h.categories.each { n ->
				c= cats.find{it.name == n}
				if(!c){ // does not have this category yet
					def cat= Category.findByName(n)
					if(!cat) cat= new Category(name: n)
					post.addToCategories(cat)
				}else{
					cats.remove(c) // take it out of the set so we know which ones to remove later
				}
			}
			
			// remove any left in this set
			cats.each { post.removeFromCategories(it) }
			
			// now do the same with the tags
			def tags= post.tags
			h.tags.split(' ').each { n ->
				t= tags.find{it.name == n}
				if(!t){ // does not have this tag yet
					def tag= Tag.findByName(n)
					if(!tag) tag= new Tag(name: n)
					post.addToTags(tag)
				}else{
					tags.remove(t) // take it out of the set so we know which ones to remove later
				}
			}
			// remove any left in this set
			tags.each { post.removeFromTags(it) }
			
			post.save(flush: true, failOnError: true)
		} catch(grails.validation.ValidationException ex) {
			throw new MyPostException(message: "validation errors: ${ex.errors}")
		} catch(org.springframework.dao.DataIntegrityViolationException ex){
			log.error("Failed to save post: ${ex.message}", ex)
			throw new MyPostException(message: "duplicate title")
		}
	}
	
	def parseUpload(rdr) {
		// we need to indent the body by one space for this version of YAML
		def str= ""
		def inBody= false
		rdr.eachLine {
			if(inBody){
				str += " $it\n"
			}else{
				if(it =~ /--- \|/){
					inBody= true
				}
				str += "$it\n"
			}
		}
		
		// read documents, there are two, the first has the params, the second is the actual post
		def doc = YAML.loadAll(str)
		def params= doc[0]
		def body= doc[1]
		
		if(!params?.title){
			throw new Exception("blank title")
		}
		
		if(!params?.categories) {
			throw new Exception("blank categories")
		}
		
		[title: params.title, categories: params.categories, tags: params.keywords, body: body]
	}

	def getCategories() {
		// TODO this pulls in all posts, which is bad this SQL query would be better...
		// select c.name, count(pc.post_id) from categories c inner join posts_categories pc on c.id=pc.category_id group by c.name
		
		def query= "select c.name, count(p) from Category c join c.posts as p group by c.name"
		def result= Category.executeQuery(query, [])
		def map = [:]
		result.each {
			map[it[0]] = it[1]
		}
		return map		
	}

	def testRawSql() {
		//def session = sessionFactory.getCurrentSession()
		def sql= "select c.name, count(pc.post_id) from categories c inner join posts_categories pc on c.id=pc.category_id group by c.name"
		Post.withSession { org.hibernate.Session session ->
			def results = session.createSQLQuery(sql).list();
			return results.toString()
		}
	}
}

class MyUserException extends RuntimeException {
	String message
	User user
}

class MyPostException extends RuntimeException {
	String message
}

