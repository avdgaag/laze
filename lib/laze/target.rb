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
      @target << child
    end

    def initialize
      Laze::LOGGER.debug "Initialized #{self.name}"
    end
  end
end