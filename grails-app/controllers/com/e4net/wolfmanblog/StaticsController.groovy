package com.e4net.wolfmanblog

class StaticsController {
	def scaffold= Static
	def blogService

	// only allow the following if not logged in
	def beforeInterceptor = [action:this.&auth]

	// defined as a regular method so its private
	def auth() {
		if(!session.user) {
			flash.message = "You must be an administrator to perform that task."
			redirect(controller: 'user', action: 'login')
			return false
		}
	}

}
