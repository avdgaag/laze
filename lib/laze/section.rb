module Laze
  # A section is a special kind of Item that maps to a filesystem directory.
  # You can move it around like an item, but it is actually a container object
  # for its subitems.
  #
  # A Section's subitems can be accessed as an Enumerable.
  class Section < Item
    include Enumerable

    def initialize(properties) #:nodoc:
      super(properties, nil)
      @items = []
    end

    def each
      @items.each { |item| yield item }
    end

    # Add a new subitem to this section.
    def add_item(item)
      @items << item
      item.parent = self
    end
    alias_method :<<, :add_item

    # Remove the given subitem from this section.
    def remove_item(item)
      @items.delete(item)
      item.parent = nil
      self
    end
    alias_method :delete, :remove_item

    # Count the number of subitems (and their subitems)
    def number_of_subitems
      @items.inject(0) { |total, item| total += 1 + item.number_of_subitems }
    end
  end
end