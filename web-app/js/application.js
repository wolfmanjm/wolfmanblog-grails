var Ajax;
if (Ajax && (Ajax != null)) {
	Ajax.Responders.register({
	  onCreate: function() {
        if($('spinner') && Ajax.activeRequestCount>0)
          Effect.Appear('spinner',{duration:0.5,queue:'end'});
	  },
	  onComplete: function() {
        if($('spinner') && Ajax.activeRequestCount==0)
          Effect.Fade('spinner',{duration:0.5,queue:'end'});
	  }
	});
}

$(document).ready(function() {
  $('.delete').click(function() {
    var answer = confirm('Are you sure?');
    return answer;
  });
});

$(document).ready(function() {
  $("a#leave_email").click(function(event){
     $("#guest_url").toggle();
     $("#guest_email").toggle();
     event.preventDefault();
  });
});
