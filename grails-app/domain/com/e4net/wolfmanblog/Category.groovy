package com.e4net.wolfmanblog

class Category {
	static mapping = {
		table 'categories'
		cache usage:'nonstrict-read-write'
	}
	static hasMany = [ posts : Post ]
	static belongsTo = Post
	
	String name
	
	static constraints = {
		name(blank: false, maxSize: 32, unique: true)
        posts()
	}

	// return a list with the category name and post count
	static getCategories() {
		// this pulls in all posts, which is bad so use a raw sql query
		// def query= "select c.name, count(p) from Category c join c.posts as p group by c.name"
		// def result= Category.executeQuery(query, [])
		def sql= "select c.name, count(pc.post_id) from categories c inner join posts_categories pc on c.id=pc.category_id group by c.name"
		Category.withSession { org.hibernate.Session session ->
			session.createSQLQuery(sql).list();
		}.collect(){ [name: it[0], count: it[1]] }
	}

}
