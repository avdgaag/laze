module Laze
  class Target

    # Generic exception to be raised for store-specific exceptions.
    TargetException = Class.new(Exception)

    # Exception for when interacting with the filesystem goes bad.
    FileSystemException = Class.new(TargetException)

    @targets = []

    # Find a target deployment engine by name and return its class.
    #
    # When loading <tt>Laze::Targets::Filesystem</tt> you would call:
    #
    #   Target.find(:filesystem)
    #
    def self.find(kind)
      targets = @targets.select { |s| s.name.to_s.split('::').last.downcase.to_sym == kind }
      raise TargetException, 'No such target.' unless targets.any?
      targets.first
    end

    def self.inherited(child) #:nodoc:
      Laze.debug "Registering target #{child}"
      @targets << child
    end

    def initialize #:nodoc:
      Laze.debug "Initialized #{self.class.name}"
    end

    # Given an item this will create the output file in the right output
    # location.
    def create(item)
      raise 'This is a generic target. Please use a subclass.'
    end
  end
end