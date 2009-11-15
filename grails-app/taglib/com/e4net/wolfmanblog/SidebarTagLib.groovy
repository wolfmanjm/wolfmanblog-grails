package com.e4net.wolfmanblog

class SidebarTagLib {
   def sidebar = { attrs ->
     def name = attrs.name
     out << "<p> $name sidbar here </p>"
  }
}
