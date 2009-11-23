import grails.util.GrailsUtil
import com.e4net.wolfmanblog.*

class BootStrap {

	def init = { servletContext ->
		switch(GrailsUtil.environment){
			case "development":
				// create an initial login account if not already there
				if(! User.findByName("admin")) {
					def admin = new User(name:"admin", password:"test", admin: true)
					admin.save()
					println "Created user 'admin' with password 'test'"
				}
				break

				case "production":
					break
			}
		}

		def destroy = {
		}
 }
