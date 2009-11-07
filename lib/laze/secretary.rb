module Laze
  class Secretary
    def self.run
      data = <<DATA
title: foo
rating: 5
@@@
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore.

Magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
@@@
<!doctype html>
<html>
  <head>
    <title>{{ page.title }}</title>
  </head>
  <body>
    {{ yield }}
  </body>
</html>
@@@
<h1>{{ page.title}}</h1>
{{ page.content }}
DATA
      metadata, content, layout1, layout2 = data.split(/\s*@@@\s*/im)
      master_layout = Layout.new(layout1)
      page_layout = Layout.new(layout2, master_layout)
      page = Item.new(YAML::load(metadata), content, page_layout)
      Template.for(:liquid, page).render
    end
  end
end