package com.e4net.wolfmanblog
/**
 * The com.e4net.wolfmanblog.Tags entity.
 *
 * @author    
 *
 *
 */
class Tag {
    static hasMany = [ posts : Post ]
    static belongsTo = [ Post ]
  
    static mapping = {
         table 'tags'
     }
    String name

    static constraints = {
        name(blank: false)
        posts()
    }
}
