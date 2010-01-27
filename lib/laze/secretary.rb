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

      # Read configuration from the laze.yml file in the current directory.
      #--
      # TODO: make sure this reads from the source directory, not the current.
      def site_config
        if File.exists?('laze.yml')
          YAML.load_file('laze.yml').symbolize_keys
        else
          {}
        end
      end
    end

    def initialize(options = {}) #:nodoc:
      default_options = {
        :store      => :filesystem,
        :target     => :filesystem,
        :source     => '.',
        :directory  => 'output',
        :minify_js  => false,
        :minify_css => false,
        :loglevel   => :warn,
        :logfile    => 'stderr'
      }
      @options = default_options.merge(self.class.site_config).merge(options)

      # Set the logger options
      logger = Logger.new((@options[:logfile] == 'stderr' ? STDERR : @options[:logfile]))
      logger.level = Logger.const_get(@options[:loglevel].to_s.upcase)
      logger.datetime_format = "%H:%M:%S"
      Laze.const_set('LOGGER', logger) unless Laze.const_defined?('LOGGER')

      Secretary.current = self
    end

    # The current storage engine.
    def store
      @store ||= Store.find(options[:store]).new(options[:source])
    end

    # The current target deployment engine.
    def target
      @target ||= Target.find(options[:target]).new(options[:directory])
    end

    # Run laze to build the output website.
    def run
      Laze.debug 'Starting source processing'
      target.reset
      store.each do |item|
        target.create item
      end
      target.save
      Laze.debug 'Source processing ready'
    end

  end
end