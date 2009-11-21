Feature: Test
  In order to test
  I will need to test

Scenario: Initial 
  Given The database contains:
    | table | column           | value                                    |
    | users | name             | testname                                 |
    | users | crypted_password | 12f0d0cf9d59500b89677e3f9f037aaa993979dc |
    | users | salt             | 46ca4885db7cd09121ef4d9c7ba2af13de40ff9e |
    | post  | title            | first post                               |
    | post  | body             | body                                     |

