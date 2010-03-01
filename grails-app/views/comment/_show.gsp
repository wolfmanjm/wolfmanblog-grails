<li class='comment' id='comment_${comment.id}'>
  <a name='comment-${comment.id}'></a>
  <cite>
    <strong>${comment.name?.encodeAsHTML()}</strong>
    said on
    <g:formatDate date='${comment.dateCreated}' style='full' type='datetime' />
  </cite>
  <br />
  <b:renderComment>
  	${comment.body}
  </b:renderComment>
</li>
