class UrlMappings {
	static mappings = {
		// http://blog.wolfman.com/articles/2009/11/11/using-postgresql-with-grails
		"/articles/$year/$month/$day/$id"(controller: 'post', action: 'show')

		// /articles/category/id
		"/articles/category/$id"(controller: 'post', action: 'listByCategory')

		// /articles/tag/id
		"/articles/tag/$id"(controller: 'post', action: 'listByTag')
		
		"/posts"(controller: 'post', action: 'index')
		"/post/new"(controller: 'post', action: 'new')
		"/post/$id"(controller: 'post', action: 'showById')
		"/post/upload"(controller: "post"){
			action= [POST:"upload"]
		}
	
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}
		"/"(view:"/index")
		"500"(view:'/error')
	}
}
