<div class='sidebar-node'>
  <h3>Tags</h3>
	<p style="overflow:hidden">
    	<g:each var='tag' in='${tags}'>
			<span style='font-size:${sizes[tag.name]}%'>
				<g:link controller='post' action='listByTag' id='${tag.name}'>
					${tag.name}
				</g:link>
			</span>
		</g:each>
	</p>
</div>