
<g:form class="commentform" name="commentform" action="addComment" controller="post" id="${post.id}" >
<div class='comment-box'>
  <div id='errors'></div>
  <div id='preview' style='display: none'></div>
  <table cellpadding='4' cellspacing='0' class='frm-tbl'>
    <tr>
      <td>
        <p><label for="name">Your name</label></p>
      </td>
      <td>
		<g:textField name="name" size="20" />
        <small>
          <a href='#' id='leave_email'>(leave url/email &#187;)</a>
        </small>
      </td>
    </tr>
    <tr id='guest_url' style='display:none;'>
      <td>

        <p><label for="url">Your blog</label></p>
      </td>
      <td>
		<g:textField class="text" name="url" />
      </td>
    </tr>
    <tr id='guest_email' style='display:none;'>
      <td>
        <p><label for="email">Your email</label></p>
      </td>

      <td>
		<g:textField class="text" name="email" />
      </td>
    </tr>
    <tr>
      <td>
        <p><label for="body">Your message</label></p>
      </td>
      <td colspan='2' valign='top'>
      	<g:textArea name="body" />
      </td>
    </tr>

    <tr>
      <td>
        <p><label for="humantest">Are you a Spambot<br>(hint: type no)</label></p>
      </td>
      <td><g:textField class="text" name="test" /></td>
    </tr>
    <tr>
      <td colspan='2' id='frm-btns'></td>

      <td class='button' id='form-submit-button'><input type="submit" name="submit" value="Submit" id="submit"/></td>
    </tr>
  </table>
</div>
</g:form>
