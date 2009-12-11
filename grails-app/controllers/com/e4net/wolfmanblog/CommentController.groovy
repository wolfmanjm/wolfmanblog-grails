package com.e4net.wolfmanblog

class CommentController {
	def scaffold = true

	// only allow the following if not logged in
	def beforeInterceptor = [action:this.&auth]

	// defined as a regular method so its private
	def auth() {
		if(!session.user) {
			log.info "unauthorized user attempted request: ${params}"
			render(status: 401, text: "You need to be logged in to do that")
			return false
		}
	}

}
