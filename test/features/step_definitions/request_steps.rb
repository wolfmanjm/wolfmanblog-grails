When /^I (DELETE|PUT) (.*) id (\d+)$/ do |method, uri, id|
  visit(uri + "/#{id}", method.downcase.to_sym)
end

When /^I POST (.*)$/ do |uri|
  visit(uri, :post)
end
