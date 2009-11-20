module Laze
  class Section < Item
    include Enumerable

    def initialize(properties)
      super(properties)
      @items = []
    end

    def each
      @items.each { |item| yield item }
    end

    def add_item(item)
      @items << item
      item.parent = self
    end
    alias_method :<<, :add_item

    def remove_item(item)
      @items.delete(item)
      item.parent = nil
    end
    alias_method :delete, :remove_item

    def number_of_subitems
      @items.inject(0) { |total, item| total += item.number_of_subitems }
    end
  end
end