Feature: Fancy permalinks
  As a web designer creating a static website
  I want to be able to set permalinks
  In order to create SEO-friendly URLs

  Scenario: Use no permalink schema
    Given I have a 'input/index.html' file that contains 'foo'
    When I run laze
    Then the output directory should exist
    And I should see 'foo' in 'output/index.html'