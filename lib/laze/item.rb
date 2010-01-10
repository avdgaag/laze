module Laze
  # An item is a basic node in a site. It is usually not used directly, but
  # only through one of its subclasses, like Page or Section. An item
  # is a basic container of properties and holds some general-purpose and
  # shared methods for its subclasses.
  class Item
    # Hash of proprties, like page title or output filename.
    attr_accessor :properties

    # Other item that has this item as one of its subitems.
    attr_accessor :parent

    # New items should be created with a hash of options:
    #
    #   Item.new :title => 'Foo'
    #
    def initialize(properties)
      @properties, @parent = properties, nil
    end

    # Test if this item has a given property.
    def has?(key)
      @properties.has_key?(key)
    end

    # Shortcut method to the filename property.
    def filename
      @properties[:filename]
    end

    def number_of_subitems
      0
    end

    # An array of items, where each item is the next's
    # parent.
    def ancestors
      parent ? [parent, *parent.ancestors].reverse : []
    end

    def to_s #:nodoc:
      filename
    end

    def inspect #:nodoc:
      "#<#{self.class}:0x#{self.object_id.to_s(16)} #{filename}>"
    end
  end
end