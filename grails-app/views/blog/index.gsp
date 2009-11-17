<%@ page import="com.e4net.wolfmanblog.Post" %>
<html>
  <head>
    <title>Simple GSP page</title>
    <meta name="layout" content="blog" />
    <syntax:resources name="code" languages="['Java', 'Groovy', 'Ruby', 'Cpp', 'Erlang', 'Plain', 'Xml']" />
  </head>

  <body>
    <div class='post'>
      <h2>
        <blog:permalink post='${post}'> ${post.title} </blog:permalink>
      </h2>
      <p class='auth'>
        Posted by Jim Morris
        <span class='typo_date'>
          on
          <g:formatDate date='${post.dateCreated}' style='full' type='datetime'></g:formatDate>
        </span>
      </p>
      
      <blog:renderHtml> ${post.forDisplay()} </blog:renderHtml>
      
      <p class='meta'>
        Posted in
        <blog:categories post='${post}'></blog:categories>
        <strong>&nbsp;|&nbsp;</strong>
        Tags
        <blog:tags post='${post}'></blog:tags>
        <strong>&nbsp;|&nbsp;</strong>
        <blog:numComments post='${post}'></blog:numComments>
      </p>
      
      <blog:permalink post='${post}'> Show </blog:permalink>
      
      |
      <g:link action='edit' controller='post' id='${post.id}'>
        Edit
      </g:link>
      <g:form name='delete' action='delete' method='delete' id= '${post.id}' >
        <g:actionSubmit value="Delete" />
      </g:form>
    </div>
    


  </body>
</html>
