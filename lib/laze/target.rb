module Laze
  class Target

    # Generic exception to be raised for store-specific exceptions.
    TargetException = Class.new(Exception)

    # Exception for when interacting with the filesystem goes bad.
    FileSystemException = Class.new(TargetException)

    @targets = []

    # The base directory to create all the files in. This is relative
    # the location where laze is run from.
    attr_reader :output_dir

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
      @targets << child
    end

    def initialize(output_dir) #:nodoc:
      @output_dir = output_dir
      reset
      Laze::Plugins.each(:target) { |plugin| extend plugin }
    end

    # Finalize the generation and process any after hooks.
    def save
      raise 'This is a generic target. Please use a subclass.'
    end

    # Given an item this will create the output file in the right output
    # location.
    def create(item)
      raise 'This is a generic target. Please use a subclass.'
    end

    # Empty the current output directory
    def reset
      FileUtils.rm_rf(output_dir) if File.directory?(output_dir)
      FileUtils.mkdir(output_dir) unless File.directory?(output_dir)
      Laze.debug "Emptied output directory #{output_dir}"
    end
  end
end