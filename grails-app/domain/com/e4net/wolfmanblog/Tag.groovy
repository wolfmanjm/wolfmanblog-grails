package com.e4net.wolfmanblog

class Tag {
    static hasMany = [ posts : Post ]
    static belongsTo = [ Post ]
  
    static mapping = {
         table 'tags'
         cache usage:'nonstrict-read-write'
     }
    String name

    static constraints = {
        name(blank: false, unique: true)
        posts()
    }

    static listWithCount(limit) {
	    def sql=
		    "SELECT tags.name, COUNT(posts_tags.post_id) AS article_counter " +
		    "FROM tags LEFT OUTER JOIN posts_tags " +
		    "ON posts_tags.tag_id = tags.id " +
		    "GROUP BY tags.name ORDER BY article_counter DESC " +
		    "LIMIT :lim"

	    def l= Tag.withSession { org.hibernate.Session session ->
		    session.createSQLQuery(sql).setInteger("lim", limit).list()
	    }

	    l.collect { t ->
		    [name: t[0], count: t[1]]
	    }   
    }
}
