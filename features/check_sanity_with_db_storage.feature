Feature: Check sanity with db storage

  As a developer
  In order to ensure that existing records are valid
  I want to run 'rake db:check_sanity' to log invalid records in the db

  Background:
    Given I have a rails app with a Gemfile requiring 'active_sanity'
    Given I run "rails generate active_sanity"
    Given I run "rake db:migrate"


  Scenario: Check sanity on empty database
    When I run "rake db:check_sanity"
    Then I should see "Checking the following models: Category, Post, User"
    Then the table "invalid_records" should be empty

  Scenario: Check sanity on database with valid records
    Given the database contains a few valid records
    When I run "rake db:check_sanity"
    Then the table "invalid_records" should be empty

  Scenario: Check sanity on database with invalid records
    Given the database contains a few valid records
    And the first user's username is empty and the first post category_id is nil
    When I run "rake db:check_sanity"
    Then the table "invalid_records" should contain:
      | User     | 1 | {:username=>["can't be blank"]} |
      | Post     | 1 | {:category=>["can't be blank"]} |

  Scenario: Check sanity on database with invalid records now valid
    Given the database contains a few valid records
    And the first user's username is empty and the first post category_id is nil
    When I run "rake db:check_sanity"
    Then the table "invalid_records" should contain:
      | User     | 1 | {:username=>["can't be blank"]} |
      | Post     | 1 | {:category=>["can't be blank"]} |

    Given the first user's username is "Greg"
    Then the table "invalid_records" should contain:
      | Post     | 1 | {:category=>["can't be blank"]} |

  Scenario: Check sanity on database with invalid records that were invalid for different reasons earlier
    Given the database contains a few valid records
    And the first user's username is empty and the first post category_id is nil
    When I run "rake db:check_sanity"
    Then the table "invalid_records" should contain:
      | User     | 1 | {:username=>["can't be blank"]} |
      | Post     | 1 | {:category=>["can't be blank"]} |

    Given the first post category is set
    And the first post title is empty
    Then the table "invalid_records" should contain:
      | Post     | 1 | {:title=>["can't be blank"]} |
