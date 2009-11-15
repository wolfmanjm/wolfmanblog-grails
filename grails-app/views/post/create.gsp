
<%@ page import="com.e4net.wolfmanblog.Post" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'post.label', default: 'Post')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir: '')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${postInstance}">
            <div class="errors">
                <g:renderErrors bean="${postInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="body"><g:message code="post.body.label" default="Body" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: postInstance, field: 'body', 'errors')}">
                                    <g:textArea name="body" cols="40" rows="5" value="${postInstance?.body}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="title"><g:message code="post.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: postInstance, field: 'title', 'errors')}">
                                    <g:textArea name="title" cols="40" rows="5" value="${postInstance?.title}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="author"><g:message code="post.author.label" default="Author" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: postInstance, field: 'author', 'errors')}">
                                    <g:textField name="author" maxlength="128" value="${postInstance?.author}" />
                                </td>
                            </tr>
                        
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="allowComments"><g:message code="post.allowComments.label" default="Allow Comments" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: postInstance, field: 'allowComments', 'errors')}">
                                    <g:checkBox name="allowComments" value="${postInstance?.allowComments}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="commentsClosed"><g:message code="post.commentsClosed.label" default="Comments Closed" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: postInstance, field: 'commentsClosed', 'errors')}">
                                    <g:checkBox name="commentsClosed" value="${postInstance?.commentsClosed}" />
                                </td>
                            </tr>
                        
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
