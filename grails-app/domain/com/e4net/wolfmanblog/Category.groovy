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
}
