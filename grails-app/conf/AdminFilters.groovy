class AdminFilters {
	// exludes is a map of controller: [action,..], which should be excluded
	def excludes= [
		post: ['index', 'showById', 'listByCategory', 'listByTag', 'show', 'addComment', 'rss', 'showRss'],
		comment: ['rss'],
		user: ['login', 'authenticate', 'logout'],
		all: ['sidebar'] // excludes all actions in this controller
	]

	def excluded(controller, action) {
		return excludes['all'].contains(controller) || excludes[controller]?.contains(action)
	}
	
	def filters = {
		loginCheck(controller:'*', action:'*') {
			before = {
				if(!session.user && !excluded(controllerName, actionName)) {
					log.info "unauthorized user attempted request: ${controllerName}- ${params}"
					render(status: 401, text: "You need to be logged in to do that")
					return false
				}
			}
		}
	}
}
