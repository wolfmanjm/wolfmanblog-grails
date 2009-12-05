<%@ page import="com.e4net.wolfmanblog.Post" %>

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="blog" />
    <st:resources name="code" languages="['Java', 'Groovy', 'Ruby', 'Cpp', 'Erlang', 'Plain', 'Xml']" />
  </head>

  <body>
	<g:if test='${!posts}'>
		<h2>Nothing found</h2>
	</g:if>
	
    <g:each var='post' in='${posts}'>
      <div class='post'>
        <h2>
          <b:permalink post='${post}'> ${post.title} </b:permalink>
        </h2>
        <p class='auth'>
          Posted by Jim Morris
          <span class='typo_date'>
            on
            <g:formatDate date='${post.dateCreated}' style='full' type='datetime'></g:formatDate>
          </span>
        </p>

        <b:renderHtml> ${post.body} </b:renderHtml>

        <p class='meta'>
          Posted in
          <b:categories post='${post}'></b:categories>
          <strong>&nbsp;|&nbsp;</strong>
          Tags
          <b:tags post='${post}'></b:tags>
          <strong>&nbsp;|&nbsp;</strong>
          <b:numComments post='${post}'></b:numComments>
        </p>

        <b:permalink post='${post}'> Show </b:permalink>

        <b:isAuthenticated>
          |
          <g:link action='edit' controller='post' id='${post.id}'>
            Edit
          </g:link>		  
		</b:isAuthenticated>
      </div>
     
    </g:each>
    <p>
      <div id='pagination'>Older posts:</div>
      <div class="paginateButtons">
      	<g:paginate total="${postCount}" max="4" id="${params.id}"/>
      </div>	
    </p>
    <b:isAuthenticated>
      <g:link action='new' controller='post'>
        New
      </g:link>
    </b:isAuthenticated>
  </body>
</html>
