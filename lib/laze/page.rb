module Laze
  class Page < Item
    include Laze::Plugin::Hookable

    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def filename
      hook_self! :filter_page_filename
      properties[:output_filename] || properties[:filename]
    end

    def render
      @rendered_content ||= begin
        # TODO: move stringify_keys into core extension
        locals = properties.inject({}) do |options, (key, value)|
          options[key.to_s] = value
          options
        end
        Liquid::Template.parse(Maruku.new(content).to_html).render('page' => locals)
      end
    end

    def to_s
      render
    end

  private

    def hook_self!(hook_name)
      hooked          = hook(hook_name, self)
      self.properties = self.properties.merge(hooked.properties)
      self.content    = hooked.content
    end
  end
end