
<form class="commentform" method="post" action="/comments/${post.id}" id="commentform"><div class='comment-box'>
  <div id='errors'></div>
  <div id='preview' style='display: none'></div>
  <table cellpadding='4' cellspacing='0' class='frm-tbl'>
    <tr>
      <td>
        <p><label for="comment[name]">Your name</label></p>
      </td>
      <td>

        <input size="20" type="text" class="text" name="comment[name]" id="comment[name]"/>
        <small>
          <a href='#' id='leave_email'>(leave url/email &#187;)</a>
        </small>
      </td>
    </tr>
    <tr id='guest_url' style='display:none;'>
      <td>

        <p><label for="comment[url]">Your blog</label></p>
      </td>
      <td><input type="text" class="text" name="comment[url]" id="comment[url]"/></td>
    </tr>
    <tr id='guest_email' style='display:none;'>
      <td>
        <p><label for="comment[email]">Your email</label></p>
      </td>

      <td><input type="text" class="text" name="comment[email]" id="comment[email]"/></td>
    </tr>
    <tr>
      <td>
        <p><label for="comment[body]">Your message</label></p>
      </td>
      <td colspan='2' valign='top'><textarea name="comment[body]" id="comment[body]"></textarea></td>
    </tr>

    <tr>
      <td>
        <p><label for="humantest">Are you a Spambot<br>(hint: type no)</label></p>
      </td>
      <td><input type="text" class="text" name="test" value="" id="humantest"/></td>
    </tr>
    <tr>
      <td colspan='2' id='frm-btns'></td>

      <td class='button' id='form-submit-button'><input type="submit" name="submit" value="Submit" id="submit"/></td>
    </tr>
  </table>
</div>
</form>
