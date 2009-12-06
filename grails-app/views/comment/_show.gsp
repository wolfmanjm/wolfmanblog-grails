<li class='comment' id='comment_${comment.id}'>
  <a name='comment-${comment.id}'></a>
  <cite>
    <strong>${comment.name?.encodeAsHTML()}</strong>
    said on
    <g:formatDate date='${comment.dateCreated}' style='full' type='datetime' />
  </cite>

  <b:isAuthenticated>
  	<g:link controller='comment' action='edit' id='${comment.id}'>Edit</g:link>
  </b:isAuthenticated>
  <br />
  <b:renderComment>
  	${comment.body}
  </b:renderComment>
</li>
