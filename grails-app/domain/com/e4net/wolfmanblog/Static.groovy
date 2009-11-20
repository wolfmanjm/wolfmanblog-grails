package com.e4net.wolfmanblog
/**
 * The Statics entity.
 *
 * @author    
 *
 *
 */
class Static {
    static mapping = {
         table 'statics'
		 body type: 'text'
    }
    String title
    String body
    Integer pos

    static constraints = {
        title(blank: false)
        body(blank: false)
        pos(nullable: true)
    }

}
