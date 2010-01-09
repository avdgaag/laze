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

    def to_s
      filename
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)} #{filename}>"
    end
  end
end