package com.e4net.wolfmanblog
/**
 * The Posts entity.
 *
 * @author
 *
 *
 */
class Post {

  static hasMany = [ comments : Comment, tags : Tag ]

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
  Date dateUpdated

  static constraints = {
    body(blank: false, maxSize: 9999999)
    title(blank: false, maxSize: 255)
    author(maxSize: 128)
    permalink(blank: false, maxSize: 255)
    guid(blank: false)
    allowComments(nullable: true)
    commentsClosed(nullable: true)
  }

//  def beforeCreate = {
//    // setup permalink
//    // create a guid
//    guid= UUID.randomUUID().toString().replaceAll('-', '')
//  }
//  
}
