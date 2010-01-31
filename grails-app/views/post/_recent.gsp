<div class='sidebar-node'>
  <h3>Recently Updated</h3>
  <div>
    <ul>
	  <g:each var='post' in='${posts}'>
		<li>
          <b:permalink post='${post}'> ${post.title} </b:permalink>
          <br />
		</li>
	  </g:each>
    </ul>
  </div>
</div>
