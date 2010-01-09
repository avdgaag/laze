module Laze
  class Page < Item
    include Laze::Plugin::Hookable

    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def filename
      @filename ||= properties[:filename].sub(/(?:md|mkd|liquid|markdown)$/, 'html')
    end

  private

    def hook_self!(hook_name)
      hooked          = hook(hook_name, self)
      self.properties = self.properties.merge(hooked.properties)
      self.content    = hooked.content
    end
  end
end