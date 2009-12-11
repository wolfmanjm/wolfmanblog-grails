package com.e4net.wolfmanblog

class UserController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	// only allow the following if not logged in
	def beforeInterceptor = [action:this.&auth, except:['login', 'authenticate', 'logout']]

	def blogService

	// defined as a regular method so its private
	def auth() {
		if(!session.user) {
			flash.message = "You must be an administrator to perform that task."
			redirect(controller: 'user', action: 'login')
			return false
		}
	}

	def login = { }

	def authenticate = {
		def user = User.findByName(params.login)

		if(user && [params.password, user.salt].encodeAsPassword() == user.cryptedPassword){
			session.user = user
			log.info "User ${user.name} logged in"
			flash.message = "Logged in as ${user.name}!"
			redirect(controller:"post", action:"index")
		}else{
			log.info "User ${user.name} failed to log in"
			flash.message = "Login failed ${params.login}"
			redirect(action:"login")
		}
	}

	def logout = {
		log.info "User ${session.user.name} logged out"
		flash.message = "Goodbye ${session.user.name}"
		session.user = null
		redirect(controller:"post", action:"list")
	}



	def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.max.toInteger() : 10, 100)
        [userInstanceList: User.list(params), userInstanceTotal: User.count()]
    }

    def create = {
        def userInstance = new User()
        userInstance.properties = params
        return [userInstance: userInstance]
    }

    def save = {
		try {
			// We need to run it under a transaction in case we get a database exception
			def userInstance= blogService.createNewUser(params)
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])}"
			redirect(action: "show", id: userInstance.id)
		} catch (MyUserException ex) {
			if(ex.message){
				// This was a database exception
				flash.message = ex.message
				redirect(action: "create")
			}else // this would be a validation error
				render(view: "create", model: [userInstance: ex.user])
		}
    }

    def show = {
        def userInstance = User.get(params.id)
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
            [userInstance: userInstance]
        }
    }

    def edit = {
        def userInstance = User.get(params.id)
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [userInstance: userInstance]
        }
    }

    def update = {
        def userInstance = User.get(params.id)
        if (userInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (userInstance.version > version) {
                    
                    userInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'user.label', default: 'User')] as Object[], "Another user has updated this User while you were editing")
                    render(view: "edit", model: [userInstance: userInstance])
                    return
                }
            }
            userInstance.properties = params
            if (!userInstance.hasErrors() && userInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])}"
                redirect(action: "show", id: userInstance.id)
            }
            else {
                render(view: "edit", model: [userInstance: userInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def userInstance = User.get(params.id)
        if (userInstance) {
            try {
                userInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
    }
}
