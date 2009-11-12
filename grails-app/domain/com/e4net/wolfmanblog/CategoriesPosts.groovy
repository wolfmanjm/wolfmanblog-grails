package com.e4net.wolfmanblog

/**
 * The com.e4net.wolfmanblog.CategoriesPosts entity.
 *
 * @author    
 *
 *
 */
class CategoriesPosts {
    static mapping = {
         table 'categories_posts'
         // version is set to false, because this isn't available by default for legacy databases
         version false
         id generator:'identity', column:'id'
         postIdPosts column:'post_id'
         categoryIdCategories column:'category_id'
    }
    Long id
    // Relation
    Post postIdPosts
    // Relation
    Category categoryIdCategories

    static constraints = {
        id()
        postIdPosts()
        categoryIdCategories()
    }
    String toString() {
        return "${id}" 
    }
}
