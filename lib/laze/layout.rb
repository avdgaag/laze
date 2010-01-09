module Laze
  class Layout < Item

    YIELD = /\{\{\s*yield\s*\}\}/
    SINGLE_LINE_YIELD = /^(\s+)#{YIELD}\s*$/

    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def wrap(string)
      if content =~ SINGLE_LINE_YIELD
        whitespace = $1
        content.sub(SINGLE_LINE_YIELD, string.split(/\n/).map { |l| whitespace + l }.join("\n"))
      else
        content.sub(YIELD, string)
      end
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