package com.e4net.wolfmanblog

class BlogService {

    boolean transactional = true

	def createNewUser(params) {
		def userInstance = new User(params)
		def ok
		try {
			ok= userInstance.save(flush: true)
		} catch (org.springframework.dao.DataIntegrityViolationException ex) {
			log.warn("Data Integrity Exception", ex)
			throw new MyUserException(message: "Username must be Unique", user: userInstance)
		}
		if(!ok){
			throw new MyUserException(message: "", user: userInstance)
		}
		return userInstance
    }
}

class MyUserException extends RuntimeException {
	String message
	User user
}