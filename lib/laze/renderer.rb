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

    def initialize(item) #:nodoc:
      raise ArgmentError, 'Please provide an item' unless item.kind_of?(Item)
      @string  = item.content
      @options = { :locals => item.properties }
    end

    # Convert the item to a string to be output to the deployment target.
    def render
      raise 'This is a generic store. Please use a subclass.'
    end

    # Shortcut method to <tt>new(...).render</tt>
    # This will automatically select the right subclass to use for the
    # incoming item.
    def self.render(item)
      case item
      when Page: Renderers::PageRenderer
      when Stylesheet: Renderers::StylesheetRenderer
      when Javascript: Renderers::JavascriptRenderer
      end.new(item).render
    end
  end
end