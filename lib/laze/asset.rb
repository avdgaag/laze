module Laze
  class Asset < Item # :nodoc:
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