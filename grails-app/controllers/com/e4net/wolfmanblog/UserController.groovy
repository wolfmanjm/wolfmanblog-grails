package com.e4net.wolfmanblog

class UserController {

    def scaffold = true
	
	def login = {
    	render(status: 412, text: "You must be logged in")	
	}
}
