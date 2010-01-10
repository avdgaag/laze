module Laze
  class Stylesheet < Item
    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def filename
      @filename ||= properties[:filename].sub(/(?:less)$/, 'html')
    end
  end
end