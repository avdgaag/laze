module Laze
  class Item
    include Laze::Layoutable

    attr_accessor :content, :properties, :layout

    def initialize(content, properties, layout = nil)
      @content, @properties, @layout = properties, content, layout
    end
  end
end