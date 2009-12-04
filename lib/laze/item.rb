module Laze
  class Item
    attr_accessor :properties, :parent

    def initialize(properties)
      @properties, @parent = properties, nil
    end

    def has?(key)
      @properties.has_key?(key)
    end

    def filename
      @properties[:filename]
    end

    def number_of_subitems
      0
    end

    def ancestors
      parent ? [parent, *parent.ancestors].reverse : []
    end
  end
end