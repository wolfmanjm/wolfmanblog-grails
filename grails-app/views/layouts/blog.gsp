<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang='en_us' xml:lang='en_us' xmlns='http://www.w3.org/1999/xhtml'>
  <head>
    <title>Wolfmans Howlings</title>
    <meta content='text/html; charset=utf-8' http-equiv='content-type' />
    %{--<link href='/posts.rss' rel='alternate' title='RSS' type='application/rss+xml' />--}%

    <link charset='utf-8' href="<g:createLinkTo dir='css' file='brighthouse.css' />" media='screen' rel='stylesheet' type='text/css' />
    <link charset='utf-8' href="<g:createLinkTo dir='css' file='local.css' />" media='screen' rel='stylesheet' type='text/css' />
    <!-- %script{ :src => "/javascripts/jquery.form.js", :type => "text/javascript"} -->
    <g:layoutHead />
    <g:javascript library="jquery" />
    <g:javascript library="application" />
  </head>

  <body>
    <div id='wrapper'>
      <div id='blog-header'>
        <h1>
          <g:link controller="post" action="index"> Wolfmans Howlings </g:link>
        </h1>
        <h2>A programmers Blog about Programming solutions and a few other issues</h2>
      </div>
      <div id='main-wrapper'>
        <div id='main-content'>
          <b:isAuthenticated>
            <p class='logged-in'> Logged in as wolfman </p>
          </b:isAuthenticated>

          <g:if test="${flash.message}">
			<p class="flash">${flash.message}</p>
		  </g:if>
          
          <g:layoutBody />

        </div>

        <div id='sidebar'>
          <g:render template="/statics/googleSearch" />
          <g:render template="/statics/contact"/>
          <g:render template="/statics/links" />
          <g:render template="/statics/syndicate" />
          <g:include controller="sidebar" action="categories" />
          <g:include controller="sidebar" action="tags" />
 	      <g:include controller="sidebar" action="recentComments" />
          <g:include controller="sidebar" action="recentPosts" />
          <g:include controller="sidebar" action="statics" />
        </div>
      </div>

      <div id='footer'>
        <p>
          Site hosted by
          <a href="http://e4net.com">e4 Networks</a>
          using
          <a href="http://github.com/wolfmanjm/wolfmanblog_grails/tree/master">wolfmanblog</a>
          and
          <a href="http://grails.org">Grails</a>
        </p>

        <ul>
          <li>
            <a href="http://www.height1percent.com/pages/brighthouse/">Brighthouse</a>
            theme by
            <a href="http://www.height1percent.com/">Richard White</a>
          </li>
        </ul>
      </div>

    </div>
  </body>
</html>
