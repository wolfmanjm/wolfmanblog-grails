When /^I (GET|DELETE|PUT|POST) (.*)$/ do |method, uri|
  visit(path_to(uri), method.downcase.to_sym)
end

# creates n posts
Given /^(\d+) posts? exists?$/ do |n|
  for i in (1..n.to_i) do
    @dbhelper.add_post(:id => i, :title => "post #{i}", :body => "body of post #{i}", :permalink => "post-#{i}")
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

When /^I leave an? (in)?valid comment$/ do |t|
  When 'I fill in "name" with "comment-user"'
  And 'I fill in "body" with "my comment message"'
  And 'I fill in "test" with ' + (t.nil? ? '"no"' : '"blahblahblah"')
  And 'I press "Submit"'
end

