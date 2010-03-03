
<%@ page import="com.e4net.wolfmanblog.Post" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'post.label', default: 'Post')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir: '')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'post.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="body" title="${message(code: 'post.body.label', default: 'Body')}" />
                        
                            <g:sortableColumn property="title" title="${message(code: 'post.title.label', default: 'Title')}" />
                        
                            <g:sortableColumn property="author" title="${message(code: 'post.author.label', default: 'Author')}" />
                        
                            <g:sortableColumn property="permalink" title="${message(code: 'post.permalink.label', default: 'Permalink')}" />
                        
                            <g:sortableColumn property="guid" title="${message(code: 'post.guid.label', default: 'Guid')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${postInstanceList}" status="i" var="postInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="edit" id="${postInstance.id}">${fieldValue(bean: postInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: postInstance, field: "body")}</td>
                        
                            <td>${fieldValue(bean: postInstance, field: "title")}</td>
                        
                            <td>${fieldValue(bean: postInstance, field: "author")}</td>
                        
                            <td>${fieldValue(bean: postInstance, field: "permalink")}</td>
                        
                            <td>${fieldValue(bean: postInstance, field: "guid")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${postInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
