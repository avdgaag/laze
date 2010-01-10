module Laze
  class Renderer

    attr_reader :options, :string

    def initialize(item)
      raise ArgmentError, 'Please provide an item' unless item.kind_of?(Item)
      @string  = item.content
      @options = { :locals => item.properties }
    end

    def render
      raise 'This is a generic store. Please use a subclass.'
    end

    # Shortcut method to <tt>new(...).render</tt>
    def self.render(item)
      case item
      when Page: Renderers::PageRenderer
      when Stylesheet: Renderers::StylesheetRenderer
      when Javascript: Renderers::JavascriptRenderer
      end.new(item).render
    end
  end
end