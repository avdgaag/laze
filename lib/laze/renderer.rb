module Laze
  # The renderer takes an item and creates output to write to the target.
  # This is a generic rendering class, which will dispatch various Item's
  # to specialised subclasses, like PageRenderer or StylesheetRenderer.
  #
  # This class's +render+ method will commonly be used to create and call a
  # new renderer.
  class Renderer

    # Options for rendering. The +:locals+ key will also contain any
    # variables to be available in the liquid templates.
    attr_reader :options

    # The string contents to render
    attr_reader :string

    def initialize(item_or_string, options = nil) #:nodoc:
      raise ArgumentError, 'Please provide an item' unless item_or_string.kind_of?(Item) || (item_or_string.is_a?(String) && options.is_a?(Hash))
      if item_or_string.is_a?(Item)
        @string  = item_or_string.content
        @options = { :locals => item_or_string.properties }
      else
        @string = item_or_string
        @options = { :locals => options }
      end

      # Add plugins
      Plugins.each(self.class.to_s) { |p| extend p }
    end

    # Convert the item to a string to be output to the deployment target.
    def render
      raise 'This is a generic store. Please use a subclass.'
    end

    # Shortcut method to <tt>new(...).render</tt>
    # This will automatically select the right subclass to use for the
    # incoming item.
    def self.render(item, locals = {})
      case item
      when Page: Renderers::PageRenderer
      when Stylesheet: Renderers::StylesheetRenderer
      when Javascript: Renderers::JavascriptRenderer
      end.new(item).render(locals)
    end
  end
end