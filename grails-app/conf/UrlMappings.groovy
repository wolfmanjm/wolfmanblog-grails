class UrlMappings {
	static mappings = {
		// http://blog.wolfman.com/articles/2009/11/11/using-postgresql-with-grails
		name article:"/articles/$year/$month/$day/$id"{
			controller= 'post'
			action= 'show'
		}

		// for old links
		"/posts/$id"(controller: 'post', action: 'showById')
		
		// /articles/category/id
		"/articles/category/$id"(controller: 'post', action: 'listByCategory')

		// /articles/tag/id
		"/articles/tag/$id"(controller: 'post', action: 'listByTag')
		
		"/posts/upload"(controller: 'post', action: 'upload')
		"/posts/$id"{
			controller= 'post'
			action= 'showById'
			constraints {
				id(matches:/\d+/)
			}
		}
		"/posts"(controller: 'post', action: 'index')
	
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}
		"/"(view:"/index")
		"500"(view:'/error')
	}
}
