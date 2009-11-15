package com.e4net.wolfmanblog
/**
 * The Posts entity.
 *
 * @author
 *
 *
 */
class Post {

    static hasMany = [ comments : Comment, tags : Tag, categories: Category]

    static mapping = {
        table 'posts'
        body type: 'text'
        comments sort: 'dateCreated'
    }
    
    String body
    String title
    String author
    String permalink
    String guid
    Boolean allowComments
    Boolean commentsClosed
    Date dateCreated
    Date lastUpdated

    static constraints = {
        body(blank: false, maxSize: 9999999)
        title(blank: false, maxSize: 255)
        author(maxSize: 128, nullable: true)
        permalink(maxSize: 255, nullable: true)
        guid(maxSize: 64, nullable: true)
        allowComments(nullable: true)
        commentsClosed(nullable: true)
        comments()
        tags()
    }

    def beforeInsert() {
        // create a guid
        guid= UUID.randomUUID().toString().replaceAll('-', '')
        // create the permalink
        permalink= title.encodeAsPermalink()
    }
    
}
