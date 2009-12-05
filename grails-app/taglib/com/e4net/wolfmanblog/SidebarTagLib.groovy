package com.e4net.wolfmanblog

class SidebarTagLib {
	static namespace = 'sidebar'
	def blogService

	def categories = {
		def m= blogService.getCategories()
		out << render(template: '/category/categories', model: ['categories': m.collect{k,v -> [name: k, count: v]}])
	}

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
		
		out << "<div class='sidebar-node'>\n"
		out << "<h3>Tags</h3>\n"
		out << '<p style="overflow:hidden">\n'
		tags.sort{x,y -> x.name <=> y.name}.each { tag ->
			out << "<span style='font-size:${sizes[tag.name]}%'>"
			out << link(controller: 'post', action: 'listByTag', id: tag.name){ tag.name }
			out << "</span>\n"
		}
	
		out << "</p>"
		out << "</div>"
	}

	def recentComments = {
		def comments= Comment.list(fetch:[post:"eager"], max: 10, sort: 'dateCreated', order:'desc')
		out << render(template: '/comment/recent', model: ['comments': comments])
	}
}
