module Laze
  class Page < Item
    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def filename
      @filename ||= properties[:filename].sub(/(?:md|mkd|liquid|markdown)$/, 'html')
    end
  end
end