require 'webrat'
require 'sequel'
require 'spec/expectations'

Webrat.configure do |config|
  config.mode = :mechanize
end

class MechanizeWorld < Webrat::MechanizeAdapter
  include Webrat::Matchers
  include Webrat::Methods

  # no idea why we need this but without it response_code is no always recognized
  Webrat::Methods.delegate_to_session :response_code, :response_body
end

World do
  MechanizeWorld.new
end

#World(Webrat::Methods)
#World(Webrat::Matchers)

# runs before each Scenario
Before do
  @dbhelper= DBHelper.new('test', false)
  @dbhelper.clean
end

After do
  @dbhelper.close
end
