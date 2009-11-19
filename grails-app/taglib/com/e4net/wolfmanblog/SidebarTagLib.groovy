package com.e4net.wolfmanblog

class SidebarTagLib {
	static namespace = 'sidebar'

	def sidebar = {attrs ->
		def name = attrs.name
		out << "<p> $name sidbar here </p>"
	}
}
