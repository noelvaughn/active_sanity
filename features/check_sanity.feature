Feature: Check sanity

  As a developer
  In order to ensure that existing records are valid
  I want to run 'rake db:check_sanity' and see which records are invalid

  Scenario: Check sanity on empty database
    Given I have a rails app with a Gemfile requiring 'active_sanity'
    When I run "rake db:check_sanity"
    Then I should not see any invalid records
