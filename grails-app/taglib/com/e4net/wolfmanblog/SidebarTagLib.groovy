package com.e4net.wolfmanblog

class SidebarTagLib {
	static namespace = 's'

	def sidebar = {attrs ->
		def name = attrs.name
		out << "<p> $name sidbar here </p>"
	}
}
