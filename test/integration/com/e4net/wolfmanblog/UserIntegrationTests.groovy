package com.e4net.wolfmanblog

import grails.test.*

class UserIntegrationTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testFirstSaveEver() {
        def user = new User(name: 'joe', password: 'test')
        assertNotNull user
        assertTrue user.validate()
        assertNotNull user.save()
        assertNotNull user.id
        def foundUser = User.get(user.id)
        assertEquals 'joe', foundUser.name
    }

    void testNameConstraints() {
        def user = new User(name: 'j', cryptedPassword: 'erer', salt: 'sdsd', admin: false)
        assertFalse user.validate()
        assertTrue user.hasErrors()

        //println user.errors

        assertNull user.save()

        user = new User(cryptedPassword: 'erer', salt: 'sdsd', admin: false)
        assertFalse user.validate()
        //println user.errors
        assertNull user.save()

        user = new User(name: 'joe', cryptedPassword: 'erer', salt: 'sdsd', admin: false)
        assertNotNull user.save()
        def user2 = new User(name: 'joe', cryptedPassword: 'erer', salt: 'sdsd', admin: false)
        assertFalse user2.validate()
        //println user2.errors
        assertNull user2.save()

    }

    void testPostWithTags() {
        def tagGroovy = new Tag(name: 'groovy')
        def tagGrails = new Tag(name: 'grails')

        def groovyPost = new Post(body: "A groovy post")
        groovyPost.addToTags(tagGroovy)
        assertEquals 1, groovyPost.tags.size()

        def bothPost = new Post(body: "A groovy and grails post")
        bothPost.addToTags(tagGroovy)
        bothPost.addToTags(tagGrails)
        assertEquals 2, bothPost.tags.size()

        assertEquals 2, tagGroovy.posts.size()
        assertEquals 1, tagGrails.posts.size()

        bothPost.delete()
        assertFalse Post.exists(bothPost.id)

//        tagGroovy.refresh()
//        tagGrails.refresh()

        assertEquals 2, tagGroovy.posts.size() // wrong
        assertFalse Tag.exists(tagGrails.id)

    }
}
