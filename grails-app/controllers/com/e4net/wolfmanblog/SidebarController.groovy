package com.e4net.wolfmanblog
import grails.plugin.springcache.annotations.Cacheable

class SidebarController {
	
	// create the tag soup
	@Cacheable("sidebarCache")
	def tags = {         		
		def tags= Tag.listWithCount(20)		
		def total= tags.inject(0) { total, tag -> total += tag.count }
		def average = total.toFloat() / tags.size()
		
		def sizes = tags.inject([:]) { h,tag ->
			// create a percentage
			def p= (tag.count.toFloat() / average)
			// apply a lower limit of 50% and an upper limit of 200%
			h[tag.name]= [[2.0/3.0, p].max(), 2].min() * 100
			h
		}
		
		[tags: tags.sort{x,y -> x.name <=> y.name}, sizes: sizes]
	}
	
	@Cacheable("sidebarCache")
	def categories = {
		[categories: Category.getCategories()]
	}
	
	@Cacheable("postsCache")
	def recentComments = {
		[comments:  Comment.list(fetch:[post:"eager"], max: 10, sort: 'dateCreated', order:'desc')]
	}
	
	@Cacheable("sidebarCache")
	def statics = {
		[statics: Static.listOrderByPosition()]
	}
	
	@Cacheable("postsCache")
	def recentPosts = {
		[posts: Post.listOrderByLastUpdated(order:"desc", max: 5)]
	}
}
