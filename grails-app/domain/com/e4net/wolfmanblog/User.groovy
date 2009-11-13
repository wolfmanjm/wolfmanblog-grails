package com.e4net.wolfmanblog

import org.apache.commons.lang.StringUtils

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
    
    String password
    String name
    String cryptedPassword
    String salt
    Boolean admin
    Date dateCreated
    
    static transients = ['password']

    void setPassword(String powd) {
        if(! StringUtils.isBlank(powd)){
            this.salt= UUID.randomUUID().toString()
            this.cryptedPassword=  [powd, salt].encodeAsPassword()
        }
    }

    static constraints = {
        name(size: 3..20, unique: true)
        admin(nullable: true)
        salt(maxSize: 64, blank: false)
        cryptedPassword(maxSize: 64, blank: false)
    }
}
