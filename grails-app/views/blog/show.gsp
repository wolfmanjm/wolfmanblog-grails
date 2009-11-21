<%@ page import="com.e4net.wolfmanblog.Post" %>

<html>
  <head>
    <meta name="layout" content="blog" />

    %{--<syntax:resources languages='${scanCodeLanguages(post)}' name='code' />--}%
    %{--<syntax:resources name="code" languages="['Java', 'Groovy', 'Ruby', 'Cpp', 'Erlang', 'Plain', 'Xml']" />--}%
  </head>
  <body>
    <div class='post'>
      <h2>${post.title}</h2>
      <p class='auth'>
        Posted by Jim Morris
        <span class='typo_date'>
          on
          <g:formatDate date='${post.dateCreated}' style='full' type='datetime'></g:formatDate>
        </span>
      </p>

      <blog:renderHtml>
        ${post.forDisplay()}
      </blog:renderHtml>

      <p class='meta'>
        Posted in
        <blog:categories post='${post}' />
        <strong>&nbsp;|&nbsp;</strong>
        Tags
        <blog:tags post='${post}' />
        <strong>&nbsp;|&nbsp;</strong>
        <blog:numComments post='${post}' />
      </p>

      <blog:isAuthenticated>
        <g:link action='edit' controller='post' id='${post.id}'>Edit</g:link>
        <g:form action='delete' id='${post.id}' method='delete' name='delete'>
          <g:actionSubmit value='Delete' />
        </g:form>
      </blog:isAuthenticated>

      <g:if test='${post.allowComments || post.comments?.size() > 0}'>
        <a name='comments'></a>
        <h4 class='blueblk'>Comments</h4>
        <g:if test='${!post.commentsClosed}'>
          <p class='postmetadata alt'>
            <small>
              <g:link url="#respond">
                Leave a response
              </g:link>
            </small>
          </p>
        </g:if>
        <ol class='comment-list' id='commentList'>
          <g:if test='${!post.comments}'>
            <li id='dummy_comment' style='display: none'></li>
          </g:if>
          <g:else>
            <g:render collection='${post.comments}' template='/comment/show' var='comment' />
          </g:else>
        </ol>
      </g:if>
      <p class='postmetadata alt'>
        <small>
          <blog:permalink format='rss' post='${post}' title='RSS Feed'>
            RSS feed for this post
          </blog:permalink>
        </small>
      </p>
      <a name='respond'></a>
      <g:render model="[post:post]" template='/comment/form' />
    </div>
  </body>
</html>