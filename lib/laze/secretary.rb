module Laze
  # The Secretary combines all other classes to a working application and
  # serves as a central point of information for other classes that need to
  # know stuff that are none of their primary concern.
  #
  # The secretary keeps track of the build options and the storage and
  # target engines that are currently used.
  class Secretary

    # Options that tell Laze what to do and how to do it.
    attr_reader :options

    class << self
      # Since there should only be a singe secretary object, we let the
      # singleton class keep track of the current instance.
      attr_accessor :current

      def site_config
        if File.exists?('laze.yml')
          Laze.debug 'Reading laze.yml'
          YAML.load_file('laze.yml').symbolize_keys
        else
          Laze.info 'No laze.yml file found; using defaults.'
          {}
        end
      end
    end

    def initialize(options = {}) #:nodoc:
      default_options = {
        :store      => :filesystem,
        :target     => :filesystem,
        :directory  => 'output',
        :minify_js  => false,
        :minify_css => false
      }
      @options = default_options.merge(self.class.site_config).merge(options)
      Secretary.current = self
    end

    # The current storage engine.
    def store
      @store ||= Store.find(options[:store]).new
    end

    # The current target deployment engine.
    def target
      @target ||= Target.find(options[:target]).new(options[:directory])
    end

    # Run laze to build the output website.
    def run
      Laze.debug 'Starting source processing'
      store.each do |item|
        target.create item
      end
      target.save
      Laze.debug 'Source processing ready'
    end

  end
end