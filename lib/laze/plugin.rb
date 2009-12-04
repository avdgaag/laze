module Laze
  # = Plugin
  #
  # This module provides a simple framework for implementing plugins in a Ruby
  # program. The syntax is simple:
  #
  #   Plugin.define 'My plugin' do
  #     author 'Your name'
  #     version '0.0.1'
  #     description 'do something awesome'
  #
  #     def after_save
  #       # do something awesome here
  #     end
  #   end
  #
  # == Plugin metadata
  #
  # For documentation purposes you can define plugin metadata using special
  # methods. The following properties are available:
  #
  # Author:: The plugin author's name(s)
  # Version:: The plugin version number
  # Description:: A short description of application and workings.
  # Priority:: an integer that determines when the plugin will be applied.
  #
  # == Prioritization
  #
  # Plugins are sorted on their priority before being applied. Priority
  # defaults to 10, with lower numbers meaning later application. Plugins with
  # priority 1 are applied last.
  #
  # == Defining hook methods
  #
  # A plugin is applied based on whether it responds to a hook name. So when
  # a hook ':my_hook' is called, all plugins that respond to 'my_hook' are
  # applied.
  #
  # === Hook-to-method
  #
  # You can hook into a hook call by creating a method by the same name:
  #
  #   Plugin.define 'log' do
  #     def after_save
  #       puts 'something was saved'
  #     end
  #   end
  #
  #   # Somewhere in your code
  #   hook :after_save
  #
  # === Map indirectly
  #
  # You can map one or more arbitrary methods to a hook using the +hook+
  # method in your plugin. It takes a hash of a hook name (key) and or more
  # method names as symbol (value).
  #
  #   Plugin.define 'log' do
  #     hook :after_save => [:mail_user, :log_message]
  #
  #     def mail_user
  #       # ...
  #     end
  #
  #     def log_message
  #       # ...
  #     end
  #   end
  #
  # === Return values
  #
  # A hooking action has a return value, which you may or may not use. You
  # can also pass it a variable number of arguments. Document your hooks well.
  #
  #   # somewhere in your code
  #   message = hook(:format_message, 'Message')
  #
  #   Plugin.define 'message formatter' do
  #     def format_message(msg)
  #       msg.upcase
  #     end
  #   end
  #
  # == Credits
  #
  # Copyright (c) 2009 Arjan van der Gaag
  #
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in
  # all copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  # THE SOFTWARE.
  #
  module Plugin

    # Pre-load all available plugins. This should be run at program
    # initialisation.
    def self.load_all
      Dir[File.join(File.dirname(__FILE__), 'plugins', '**', 'init.rb')].each do |filename|
        require filename
      end
      Dir[File.join(File.dirname(__FILE__), 'plugins', '*.rb')].each do |filename|
        require filename
      end
    end

    # Define a new plugin as defined by the given block.
    #
    # The block defines a new class, so any methods you define in the block
    # will be singleton methods on that class.
    #
    # You can use the special metadata DSL for describing your plugin:
    #
    #   Plugin.define 'plugin name' do
    #     author      'Your name'
    #     version     '1.0'
    #     description 'Something about your plugin'
    #
    #     # your code here...
    #   end
    #
    def self.define(name, &block)
      Base.define(name, &block)
    end

    # The hookable module should be included in every class that wants to call
    # hooks and have plugins respond.
    #
    # == Usage
    #
    # Simply include the module in your class and call +hook+ with a symbol name
    # and any available plugins will be called there.
    #
    # Optionally, your hook may accept arguments and return values.
    #
    # == Example
    #
    # You can call +hook+ to trigger plugins:
    #
    #   class Dog
    #     include Plugin::Hookable
    #     def bark
    #       hook :before_bark
    #       puts 'woof'
    #     end
    #   end
    #
    # You can also pass in arguments and/or accept return values:
    #
    #   class Dog
    #     include Plugin::Hookable
    #     def bark
    #       puts hook(:filter_bark, 'woof')
    #     end
    #   end
    #
    # This way, a plugin may take +'woof'+ as an argument and modify the
    # eventual program output.
    module Hookable
      module ClassMethods
        def wrap_hook(method_name, hook_name)
          unhooked_method_name = "unhooked_#{method_name}".to_sym
          alias_method unhooked_method_name, method_name.to_sym
          define_method method_name do |*args|
            hook(hook_name) do
              send(unhooked_method_name, *args)
            end
          end
        end
      end

      module InstanceMethods
        # Call a hook with a given name.
        #
        # This will return the cumulative output of the plugin methods.
        def hook(name, *args, &block)
          return *args unless Base.for(name).any?
          unless block_given?
            Base.for(name).inject(*args) do |output, plugin|
              plugin.send(name, output)
            end
          else
            Base.for(name).reverse.inject(block) do |memo, plugin|
              Proc.new { plugin.send(name, &memo) }
            end.call
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end

    module Sugar #:nodoc:
      # This method lets you define syntactic sugar for setting instance
      # variables, like <tt>author 'some name'</tt>.
      def def_field(*names)
        class_eval do
          names.each do |name|
            define_method(name) do |*args|
              case args.size
              when 0: instance_variable_get("@#{name}")
              else    instance_variable_set("@#{name}", *args)
              end
            end
          end
        end
      end
    end

    module Hooking #:nodoc:
      # Make sure hook actions registered using +hook+ and get called using
      # +method_missing+ are discoverable.
      def respond_to?(method_name)
        @hooks[method_name].any? || super(method_name)
      end

      # When using +hook+ to register one or more methods for a given hook name,
      # intercept any call to that hook name by calling all associated methods.
      def method_missing(method_name, *args)
        return super unless @hooks[method_name].any?
        @hooks[method_name].inject(*args) do |output, method|
          send(method, output)
        end
      end

      # Register one or more arbitrary methods to a given hook name.
      def hook(options = {})
        options.each_pair do |hook_name, method|
          @hooks[hook_name] += [*method]
        end
      end
    end

    class Base #:nodoc:
      @registered_plugins = {}
      class << self
        # List of available, registered plugins
        attr_reader :registered_plugins

        # Make sure nobody can create a new Plugin other than Plugin itself.
        private :new

        # Define a new instance of this class using a block, and remember it as
        # an available plugin.
        def define(plugin_name, &block)
          p = new
          p.instance_eval { name plugin_name }
          p.instance_eval(&block)
          registered_plugins[plugin_name] = p
          p
        end

        # Collect all plugins that will respond to a given hook name. Prioritize
        # them and return them in order.
        def for(hook_name)
          @registered_plugins.values.select { |plugin|
            plugin.respond_to?(hook_name)
            }.sort
          end
        end

        def initialize
          @hooks = Hash.new([])
          @priority = 10
        end

        def to_s
          "#{name} #{version} by #{author}: #{description}"
        end

        def <=>(other)
          raise ArgumentError, "A plugin is not comparable with #{other}" unless other.kind_of?(Plugin::Base)
          (self.priority <=> other.priority) * -1
        end

        include Hooking
        include Comparable
        extend Sugar

        # Set up metadata properties
        def_field :name, :author, :version, :priority, :description
      end
    end
end