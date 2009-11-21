Then /^I should see an? (\w+) message$/ do |message_type|
  response_body.should have_xpath("//*[@class='#{message_type}']")
end

Then /^the (.*) ?request should fail/ do |_|
  response_code.should_not == 200
end

Then /^the (.*) ?request should succeed/ do |_|
  response_code.should == 200
end

Then /^the (.*) ?request should return status (\d+)/ do |_, status|
  response_code.should == status.to_i
end

Then /^the (.*) ?request should redirect to (.*)$/ do |_, uri|
  response.should redirect_to(uri)
end

# creates n posts
Given /^(\d+) posts? exists?$/ do |n|
  for i in (1..n.to_i) do
    @dbhelper.add_post(:id => i, :title => "post #{i}", :body => "body of post #{i}", :permalink => "post-#{i}")
  end
end

Then /^I should see post (\d+)$/ do |n|
  y= Time.now.year
  m= Time.now.month
  d= Time.now.day
  response_body.should have_xpath("//h2/a[@href='/articles/#{y}/#{m}/#{d}/post-#{n}']['post #{n}']")
  response_body.should have_selector("p:contains('body of post #{n}')")
end

Then /^I should not see post (\d+)$/ do |n|
  response_body.should_not have_selector("p:contains('body of post #{n}')")
end

Then /^I should see only post (\d+)$/ do |n|
  response_body.should have_selector("div.post h2:contains('post #{n}')")
  response_body.should have_selector("p:contains('body of post #{n}')")
  response_body.should have_selector("form.commentform")
end

When /^I leave an? (in)?valid comment$/ do |t|
  When 'I fill in "comment[name]" with "comment-user"'
  And 'I fill in "comment[body]" with "my comment message"'
  And 'I fill in "test" with ' + (t.nil? ? '"no"' : '"blahblahblah"')
  And 'I press "Submit"'
end

Then /^I should (not)? ?see the comment$/ do |t|
  comment_user= "ol.comment-list li.comment cite strong:contains('comment-user')"
  comment_body= "ol.comment-list li.comment:contains('my comment message')"
  if t.nil?
    response_body.should have_selector(comment_user)
    response_body.should have_selector(comment_body)
  else
    response_body.should_not have_selector(comment_user)
    response_body.should_not have_selector(comment_body)
  end
end

Then /^I should see an unordered list containing (\d+) posts within "([^\"]*)"$/ do |nitems, selector|
  within(selector) do |content|
    for i in (1..nitems.to_i) do
      content.should have_selector("li a:contains('post #{i}')")
    end
  end
end

Given /^post (\d+) is tagged "([^\"]*)"$/ do |id, tags|
  a= tags.split(',')
  a.each do |t|
    @dbhelper.tag_post(id.to_i, t.strip)
  end
end

Given /^post (\d+) has category "([^\"]*)"$/ do |id, cats|
  a= cats.split(',')
  a.each do |t|
    @dbhelper.categorize_post(id.to_i, t.strip)
  end
end

Then /^the post is tagged "([^\"]*)"$/ do |tags|
  tags= tags.split(',').collect{ |t| t.strip }.join(',')
  response_body.should have_selector("p.meta:contains('#{tags}')")
end

Then /^the post is in category "([^\"]*)"$/ do |cats|
  cats= cats.split(',').collect{ |t| t.strip }.join(',')
  response_body.should have_selector("p.meta:contains('#{cats}')")
end
