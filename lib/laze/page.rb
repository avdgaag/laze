module Laze
  class Page < Item
    include Laze::Layout::Layoutable

    attr_accessor :content, :layout

    def initialize(properties, content, layout = nil)
      @content, @layout = content, layout
      super(properties)
    end

    def to_s
      content
    end
  end
end