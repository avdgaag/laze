require 'ostruct'
Laze::Plugin.define 'liquid' do
  author      'Arjan van der Gaag'
  version     '1.0'
  description 'Process pages with the liquid templating language.'
  priority    8
  builtin     true

  def generate_page_content(page)
    # TODO: move stringify_keys into core extension
    locals = page.properties.inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
    page.content = Liquid::Template.parse(page.content).render 'page' => locals
    page
  end
end