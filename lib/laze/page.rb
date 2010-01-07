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

  private

    def hook_self!(hook_name)
      hooked          = hook(hook_name, self)
      self.properties = self.properties.merge(hooked.properties)
      self.content    = hooked.content
    end
  end
end