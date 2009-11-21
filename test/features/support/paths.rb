module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

      # Add more mappings here.
      # Here is a more fancy example:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

    when /http:\/\/(.*)/
      page_name

    else
      if(base=ENV['BASE_URL'])
        "#{base}#{page_name}"
      else
        "http://localhost:3000#{page_name}"
      end
      
    end
  end
end

World(NavigationHelpers)

