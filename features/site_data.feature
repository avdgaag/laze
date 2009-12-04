Feature: Site data
  As a web designer creating a static website
  I want to be able to embed data into my site
  In order to speed up development

  Scenario: use page variable in a page
    Given I have an 'input/index.html' page with title 'Foo' that contains '{{ page.title }}'
    When I run laze
    Then the output directory should exist
    And I should see 'Foo' in 'output/index.html'

  Scenario: use variables in a layout
    Given I have a layouts directory
    And I have a 'default' layout that contains '{{ page.title }}: {{ yield }}'
    And I have an 'input/index.html' page with title 'Foo' that contains 'bar'
    When I run laze
    Then the output directory should exist
    And I should see 'Foo: bar' in 'output/index.html'