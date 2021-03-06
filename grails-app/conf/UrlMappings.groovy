class UrlMappings {
	static mappings = {
		// http://blog.wolfman.com/articles/2009/11/11/using-postgresql-with-grails
		name article:"/articles/$year/$month/$day/$id"{
			controller= 'post'
			action= 'show'
		}

		// old style links using id of post
		"/posts/$id"{
			controller= 'post'
			action= 'showById'
			constraints {
				id(matches:/\d+/)
			}
		}

		// /articles/category/id
		"/articles/category/$id"(controller: 'post', action: 'listByCategory')

		// /articles/tag/id
		"/articles/tag/$id"(controller: 'post', action: 'listByTag')
		
		"/posts/upload"(controller: 'post', action: 'upload')
		"/posts"(controller: 'post', action: 'index')
	
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}
		"/"(controller: 'post', action: 'index')
		"500"(view:'/error')
	}
}
