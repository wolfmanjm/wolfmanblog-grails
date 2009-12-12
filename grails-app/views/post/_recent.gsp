<div class='sidebar-node'>
  <h3>Recent Articles</h3>
  <div style='height:400px;width:250px;overflow:scroll;'>
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
