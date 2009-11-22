<li class='comment' id='comment_${comment.id}'>
  <a name='comment-${comment.id}'></a>
  <cite>
    <strong>${comment.name?.encodeAsHTML()}</strong>
    said on
    <g:formatDate date='${comment.dateCreated}' style='full' type='datetime' />
  </cite>

  <blog:isAuthenticated>
  	TODO
    delete_button url(:delete_comment, :commentid => comment), 'Delete comment', :class => 'delete'
  </blog:isAuthenticated>
  <br />
  <blog:renderComment>
  	${comment.body}
  </blog:renderComment>
</li>
