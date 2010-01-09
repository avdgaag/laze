module Laze
  class Layout < Item

    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def wrap(string)
      content.gsub(/\{\{\s*yield\s*\}\}/, string)
    end

    def layout
      properties[:layout]
    end

    def self.find(layout_name)
      return unless layout_name
      file = Store[Secretary.options[:store]].layout(layout_name)
      new file.properties, file.content
    end
  end
end