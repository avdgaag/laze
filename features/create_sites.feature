Feature: Create sites
  As a web developer
  I want to be able to make a static website
  In order to earn a living

  Scenario: Basic site
    Given I have an 'input/index.html' file that contains 'basic site'
    When I run laze
    Then the output directory should exist
    And I should see 'basic site' in 'output/index.html'

  Scenario: Site with directories
    Given I have an 'input/contact/index.html' file that contains 'contact!'
    When I run laze
    Then the output directory should exist
    And I should see 'contact!' in 'output/contact/index.html'

  Scenario: Basic site with a layout
    Given I have a layouts directory
    And I have an 'input/index.html' page with layout 'default' that contains 'page with layout'
    And I have a 'default' layout that contains 'Layout: {{ yield }}'
    When I run laze
    Then the output directory should exist
    And I should see 'Layout: <p>page with layout</p>' in 'output/index.html'

  Scenario: Basic site with nested layouts
    Given I have a layouts directory
    And I have an 'input/index.html' page with layout 'post' that contains 'page'
    And I have a 'post' layout with layout 'default' that contains 'Post: {{ yield }}'
    And I have a 'default' layout that contains 'Layout: {{ yield }}'
    When I run laze
    Then the output directory should exist
    And I should see 'Layout: Post: <p>page</p>' in 'output/index.html'

  Scenario: Basic site with includes
    Given I have a includes directory
    And I have an 'input/index.html' file that contains 'Included: {% include \'foo\' %}'
    And I have an 'includes/foo.html' file that contains 'foo'
    When I run laze
    Then the output directory should exist
    And I should see 'Included: foo' in 'output/index.html'

  Scenario: CSS files
    Given I have an 'input/base.css' file that contains 'foo'
    When I run laze
    Then the output directory should exist
    And I should see 'foo' in 'output/base.css'

  Scenario: LESS files
    Given I have an 'input/base.less' file that contains '#foo { width: 1+1; }'
    When I run laze
    Then the output directory should exist
    And I should see '#foo \{ width: 2; \}' in 'output/base.css'

  Scenario: Javascript files
    Given I have an 'input/base.js' file that contains 'foo'
    When I run laze
    Then the output directory should exist
    And I should see 'foo' in 'output/base.js'

  Scenario: XML Sitemaps
    Given I have an 'input/test.html' file that contains 'foo'
    When I run laze
    Then the output directory should exist
    And I should see 'foo' in 'output/test.html'
    And I should see 'test.html' in 'output/sitemap.xml'