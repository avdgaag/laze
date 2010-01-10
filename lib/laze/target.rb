module Laze
  class Target
    include Enumerable

    TargetException = Class.new(Exception)
    FileSystemException = Class.new(TargetException)

    @targets = []

    def self.find(kind)
      targets = @targets.select { |s| s.name.to_s.split('::').last.downcase.to_sym == kind }
      raise TargetException, 'No such target.' unless targets.any?
      targets.first
    end

    def self.inherited(child)
      Laze::LOGGER.debug "Registering target #{child}"
      @targets << child
    end

    def initialize
      Laze::LOGGER.debug "Initialized #{self.name}"
    end

    def create(item)
      raise 'This is a generic target. Please use a subclass.'
    end
  end
end