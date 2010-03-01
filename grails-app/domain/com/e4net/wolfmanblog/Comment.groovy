package com.e4net.wolfmanblog

/**
 * The Comments entity.
 *
 * @author
 *
 *
 */
class Comment {
	static belongsTo = [ post : Post ]

	static mapping = {
		table 'comments'
		body type: 'text'
		sort dateCreated: "desc"
	}

	String name
	String body
	String email
	String url
	String guid
	Date dateCreated
	Date lastUpdated
	
	static constraints = {
		name(nullable: true)
		body(blank: false, maxSize: 64000)
		guid(nullable: true)
		email(nullable: true)
		url(nullable: true)
		post()
	}
	
	def beforeInsert() {
		// create a guid
		guid= UUID.randomUUID().toString()
	}

}
