module Laze
  class Javascript < Item
    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def filename
      properties[:filename]
    end
  end
end