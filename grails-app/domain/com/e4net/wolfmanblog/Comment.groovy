package com.e4net.wolfmanblog

/**
 * The Comments entity.
 *
 * @author
 *
 *
 */
class Comment {
  static mapping = {
    table 'comments'
    body type: 'text'
  }
  String name
  String body
  String email
  String url
  String guid
  Date dateCreated
  Date dateUpdated

  static belongsTo = [ post : Post ]

  static constraints = {
    name()
    body(blank: false, maxSize: 64000)
    email()
    url()
  }

  def beforeCreate = {
    // create a guid
    guid= UUID.randomUUID().toString().replaceAll('-', '')
  }
      
}
