package com.e4net.wolfmanblog

class SidebarTagLib {
	static namespace = 'sidebar'
	def blogService

	def categories = {attrs ->
		def m= blogService.getCategories()
//		out << "<div class='sidebar-node'>"
//        out << "<h3>Categories</h3>"
//		out << "<ul id='categories'>"
//		m.each { k, v ->
//			out << "<li><p>"
//			out << g.link(controller: 'post', action: 'listByCategory', id: k) {k}
//			out << " <em>($v)</em>"
//			out << "</p></li>"
//		}
//		out << "</ul>"
//		out << "</div>"
		out << render(template: '/category/categories', model: ['categories': m.collect{k,v -> [name: k, count: v]}])
	}

}
