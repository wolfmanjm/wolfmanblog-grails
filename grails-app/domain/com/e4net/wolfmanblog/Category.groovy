package com.e4net.wolfmanblog
/**
 * The Categories entity.
 *
 * @author    
 *
 *
 */
class Category {
    static mapping = {
         table 'categories'
    }
    String name

    static constraints = {
        name(blank: false, maxSize: 32)
    }
}
