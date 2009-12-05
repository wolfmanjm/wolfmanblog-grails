<div class='sidebar-node'>
  <h3>Recent Comments</h3>
  <div>
    <ul>
      <g:each var="comment" in="${comments}">
		<li>
		  <g:link controller="post" action="showById" id="${comment.post.id}" fragment="comment_${comment.id}">
			by ${comment.name.encodeAsHTML()} on ${comment.post.title}
		  </g:link>
		</li>
	  </g:each>
    </ul>
  </div>
</div>
