Given /^I am not authenticated$/ do
  visit path_to('/user/logout')
end

Given /^a valid user account exists$/ do
  @dbhelper.truncate(:users)
  # do this instead of using fixtures
  # eventually we can do this
#  Given 'The database contains:', table(%{
#    | table | column           | value                                    |
#    | users | name             | testname                                 |
#    | users | crypted_password | 12f0d0cf9d59500b89677e3f9f037aaa993979dc |
#    | users | salt             | 46ca4885db7cd09121ef4d9c7ba2af13de40ff9e |
#  })
  # but for now we have to do it the hard way
  @dbhelper.add_user('testname', '42880c92ca5b722a8a25d8ceca050947d7f9a9ca', '184e2617-e813-4e78-9933-07426729b903')
end

When 'I login' do
  When  'I go to /user/login'
  And 'I fill in "login" with "testname"'
  And 'I fill in "password" with "test"'
  And 'I press "Login"'
end

Then /^I should see logged in message$/ do
  response_body.should have_xpath("//*[@class='logged-in']")
  response_body.should =~ /logged in as testname/i
end


Then /dump status/ do
  # p response_body
  #puts "current_url: "
  #p request_page

#  puts "response: "
  p response_code
end
