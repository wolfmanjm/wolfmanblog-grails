package com.e4net.wolfmanblog
/**
 * The Users entity.
 *
 * @author    
 *
 *
 */
class User {
    static mapping = {
      table 'users'
    }
    String name
    String cryptedPassword
    String salt
    Boolean admin
    Date dateCreated

    static constraints = {
        name(size: 3..20, unique: true)
        cryptedPassword()
        salt()
        admin(nullable: true)
    }
}
