package com.e4net.wolfmanblog

class Category {
	static mapping = {
		table 'categories'
	}
	static hasMany = [ posts : Post ]
	static belongsTo = [ Post ]
	
	String name
	
	static constraints = {
		name(blank: false, maxSize: 32, unique: true)
        posts()
	}
}
