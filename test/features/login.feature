Feature: Login
  To ensure the safety of the application
  An admin user
  Must authenticate before doing any admin functions

  Scenario Outline: Failed Login
    Given I am not authenticated
    When I go to /user/login
    And I fill in "login" with "<mail>"
    And I fill in "password" with "<password>"
    And I press "Login"
    Then I should see message "Login failed <mail>"

    Examples:
      | mail           | password       |
      | not_an_address | nil            |
      | not@not        | 123455         |
      | 123@abc.com    | wrong_paasword |


  Scenario: Successfull Login
    Given I am not authenticated
    And a valid user account exists
    When I login
    Then the login request should succeed
    And I should see logged in message


