@plugins
Feature: Plugins
  In order to automate tasks
  As a web developer
  I want to use plugins to awesomize my website

  Scenario: CSS compression
    Given I have an 'input/screen.css' file that contains
    """
    a {
      color: #000;
    }

    """
    When I run laze with minification
    Then the output directory should exist
    And I should see 'a\{color:#000;\}' in 'output/screen.css'

  Scenario: Javascript compression
    Given I have an 'input/base.js' file that contains
    """
    var  hello  =  "world";

    """
    When I run laze with minification
    Then the output directory should exist
    And I should see 'var hello="world";' in 'output/base.js'


  Scenario: Javascript requires
    Given I have an 'input/base.js' file that contains '// require "foo.js"'
    And I have an 'input/foo.js' file that contains '// test'
    When I run laze
    Then the output directory should exist
    And I should see '// test' in 'output/base.js'

  Scenario: CSS imports
    Given I have an 'input/base.css' file that contains '@import url(bar.css)'
    And I have an 'input/bar.css' file that contains 'baaah'
    When I run laze
    Then the output directory should exist
    And I should see 'baaah' in 'output/base.css'

  Scenario: CSS cache busters
    Given I have an 'input/base.css' file that contains 'foo { background: url(test.png); }'
    And I have an 'input/test.png' file that contains 'foo'
    When I run laze
    Then the output directory should exist
    And I should see 'url\(test.png\?\d+\)' in 'output/base.css'