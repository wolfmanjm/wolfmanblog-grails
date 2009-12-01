package com.e4net.wolfmanblog
/**
 * The Posts entity.
 *
 * @author
 *
 *
 */
class Post {

	static hasMany = [ comments : Comment, tags : Tag, categories: Category ]

	static mapping = {
		table 'posts'
        body type: 'text'
        sort dateCreated: "desc"
        comments sort: 'dateCreated'
		// tags fetch:"join"
		// categories fetch:"join"
    }

	String body
	String title
	String author
	String permalink
	String guid
	Boolean allowComments
	Boolean commentsClosed
	Date dateCreated
	Date lastUpdated

	static constraints = {
		body(blank: false, maxSize: 9999999)
		title(blank: false, maxSize: 255)
		author(maxSize: 128, nullable: true)
		// make sure the permalink will be unique
		permalink(maxSize: 255, nullable: true)
		guid(maxSize: 64, nullable: true)
		allowComments(nullable: true)
		commentsClosed(nullable: true)
		comments()
		tags()
		categories()
    }
	
	def beforeInsert() {
		// create a guid
		guid= UUID.randomUUID().toString()
		// create the permalink
		permalink= title.encodeAsPermalink()
	}
	
	def getYear() {
		dateCreated[Calendar.YEAR].toString()
	}
	
	def getMonth() {
		(dateCreated[Calendar.MONTH]+1).toString()
	}
	
	def getDay() {
		dateCreated[Calendar.DAY_OF_MONTH].toString()
	}
	
	def getCommentCount() {
		Comment.countByPost(this)
	}
	
	def getCategorized() {
		// TODO not exactly optimal as it fetches from posts for no reason, but better than the n+1 selects categories does
		// what is better is this SQL select...
		/*
		def sql= "select c.name from categories c inner join posts_categories pc on c.id=pc.category_id where pc.post_id=:id"
		Tag.withSession { org.hibernate.Session session ->
			session.createSQLQuery(sql).setInteger("id", this.id).list();
		}
		*/
		
		Category.executeQuery("select c.name from Category c join c.posts as p where p.id = ?", [this.id])
	}
	
	def getTagged(){
		// even better would be...
		// select t.name from tags t, posts_tags pt where t.id = pt.tag_id and pt.post_id = ?;
		Tag.executeQuery("select t.name from Tag t join t.posts as p where p.id = ?", [this.id])
	}
}


