import grails.util.GrailsUtil
import com.e4net.wolfmanblog.*

class BootStrap {

	def init = { servletContext ->
		switch(GrailsUtil.environment){
			case "development":
				log.info "Running in Development mode"
				// create an initial login account if not already there
				if(! User.findByName("admin")) {
					def admin = new User(name:"admin", password:"test", admin: true)
					admin.save()
					log.info "Created user 'admin' with password 'test'"
				}
				break

			case "production":
				log.info "Running in Production mode"
				break
			}
		}

	def destroy = {
	}
 }
