module Laze
  class Store
    include Enumerable

    StoreException = Class.new(Exception)
    FileSystemException = Class.new(StoreException)

    @stores = []

    def self.find(kind)
      stores = @stores.select { |s| s.name.to_s.split('::').last.downcase.to_sym == kind }
      raise StoreException, 'No such store.' unless stores.any?
      stores.first
    end

    def self.inherited(child)
      Laze::LOGGER.debug "Registering store #{child}"
      @stores << child
    end

    def initialize
      Laze::LOGGER.debug "Initialized #{self.class.name}"
      Liquid::Template.file_system = self
    end

    def each
      raise 'This is a generic store. Please use a subclass.'
    end

    def find_layout(layout_name)
      raise 'This is a generic store. Please use a subclass.'
    end

    def read_template_file
      raise 'This is a generic store. Please use a subclass.'
    end
  end
end