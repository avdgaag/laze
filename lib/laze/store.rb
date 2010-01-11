module Laze
  class Store
    include Enumerable

    # Generic exception to be raised for store-specific exceptions.
    StoreException = Class.new(Exception)

    # Exception for when interacting with the filesystem goes bad.
    FileSystemException = Class.new(StoreException)

    @stores = []

    # Find a storage engine by name and return its class.
    #
    # When loading <tt>Laze::Stores::Filesystem</tt> you would call:
    #
    #   Store.find(:filesystem)
    #
    def self.find(kind)
      stores = @stores.select { |s| s.name.to_s.split('::').last.downcase.to_sym == kind }
      raise StoreException, 'No such store.' unless stores.any?
      stores.first
    end

    def self.inherited(child) #:nodoc:
      Laze.debug "Registering store #{child}"
      @stores << child
    end

    def initialize #:nodoc:
      Laze.debug "Initialized #{self.class.name}"
      Liquid::Template.file_system = self
    end

    # Loop over all the items in the current project and yield them
    # to the block.
    def each
      raise 'This is a generic store. Please use a subclass.'
    end

    # Return a new instance of Layout by finding a layout by the given name
    # in the current project.
    def find_layout
      raise 'This is a generic store. Please use a subclass.'
    end

    # Return the contents of any project file. This method is also used
    # by the Liquid templating engine to read includes.
    def read_template_file
      raise 'This is a generic store. Please use a subclass.'
    end
  end
end