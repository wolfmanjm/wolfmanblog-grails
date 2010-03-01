A Grails based Blog Engine
==========================

This is a simple blog engine, with the basic features needed for a blog.
[Originally](http://github.com/wolfmanjm/wolfmanblog) written in Merb and ported to Grails.

_NOTE_ This is still a work in progress, although it is functional.

Right now it is as functional as the Merb based wolfmanblog.

I am rather disappointed with the performance. The raw non-cached
performance is about the same as the Ruby/Merb version which is a lot
faster with the view caching turned on.

I have added the springcache plugin and started to cache selected
fragments, and have it running at least as fast as the Merb version
with caching on.

_NOTE_ version 1.2 of springcache plugin is required it can currently be installed with...

`> grails install-plugin springcache 1.2-SNAPSHOT`

The startup time of the war when in production mode is abysmal, around
90 seconds before it can accept connections, no idea why.

Funtionality
------------
* Posts are uploaded as a simple Yaml formatted file.
* The post body is in markdown format
* Has tag cloud and each post can have several tags
* Each post has a category
* There is a configurable sidebar, where you can show recent comments,
links, ads etc

Interesting points
------------------
* Uses Postgresql for the Database
* Uses a custom Hibernate Dialect for Postgresql that uses upto date
  sequences explained
  [here](http://blog.wolfman.com/articles/2009/11/11/using-postgresql-with-grails)
* Uses Cucumber and Webrat/mechanize to do integration tests
* As Grails/Hibernate does not seem to create indices on Postgresql
  I do something [different](http://wiki.github.com/wolfmanjm/wolfmanblog-grails/schema-generation)
* Uses groovy markup builder to create the rss feed XML in the controller  

TODO
----

