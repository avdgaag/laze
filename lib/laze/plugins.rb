module Laze
  # Plugins provides access to all Laze plugins.
  #
  # A plugin is a simple decorator that can wrap an Item object. Every plugin
  # itself can tell you to what objects it applies, and an Item includes
  # all available plugins by using the +include_plugins+ macro:
  #
  #   class MyItem < Item
  #     include_plugins :my_item
  #   end
  #
  # == Example
  #
  # A plugin is a simple module that usually replaces methods on Item objects.
  # Here's a simple example:
  #
  #   class MyItem < Item
  #     include_plugins :my_item
  #     def foo
  #       'bar'
  #     end
  #   end
  #
  #   module Plugins
  #     module MyPlugin
  #       def applies_to?(kind)
  #         kind == :my_item
  #       end
  #
  #       def foo
  #         super + '!'
  #       end
  #     end
  #   end
  #
  #   MyItem.new.foo # => 'bar!'
  #
  # == Working with plugins
  #
  # Usually, each plugin should have its own file, require any third-party
  # libraries and be responsible for when things go wrong.
  #
  # A plugin should be stored in /plugins, where it is automatically loaded.
  module Plugins
    # Loop over all available plugins, yielding each.
    def self.each # :yields: module
      constants.each do |c|
        const = Laze::Plugins.const_get(c)
        yield const if const.is_a?(Module)
      end
    end
  end
end

# Load all plugins from /plugins
Dir[File.join(File.dirname(__FILE__), 'plugins', '*.rb')].each { |f| require f }