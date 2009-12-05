A Grails based Blog Engine
==========================

This is a simple blog engine, with the basic features needed for a blog.
[Originally](http://github.com/wolfmanjm/wolfmanblog) written in Merb and ported to Grails.

_NOTE_ This is a work in progress, as I am learning Grails.

Right now it is nearly as functional as the Merb based wolfmanblog, just a few more tweaks are needed.

Interesting points
------------------
* Uses Postgresql for the Database
* Uses a custom Hibernate Dialect for Postgresql that uses upto date
  sequences explained
  [here](http://blog.wolfman.com/articles/2009/11/11/using-postgresql-with-grails)
* Uses Cucumber and Webrat/mechanize to do integration tests
* As Grails/Hibernate does not seem to create indices on Postgresql
  I do something [different](http://wiki.github.com/wolfmanjm/wolfmanblog-grails/schema-generation)
  

TODO
----
