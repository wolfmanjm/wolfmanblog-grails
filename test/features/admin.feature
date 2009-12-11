Feature: Admin
  To ensure the safety of the application
  A normal user
  Should not be able to delete or edit posts or comments

Scenario Outline: admin tasks when no loggged in
    Given I am not authenticated
    When I <method> <url>
    Then the request should return status 401

    Examples:

    | method | url                |
    | DELETE | /comment/delete/1  |
    | POST   | /comment/delete/1  |
    | POST   | /tag/delete/1      |
    | POST   | /category/delete/1 |
    | DELETE | /post/delete/1     |
    | POST   | /post/delete/1     |
    | POST   | /post/save/1       |
    | POST   | /post/update/1     |
    | GET    | /post/edit/1       |
    | GET    | /post/create       |
    | GET    | /post/list         |
    | POST   | /post/upload       |
    | POST   | /statics/delete/1  |
    | POST   | /user/save         |
    | POST   | /comment/save/1    |
