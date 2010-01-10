module Laze
  # Minifier is kind of renderer that optimizes the output of assets like
  # javascripts and stylesheets. This makes sure these are not processed by
  # markdown and liquid, but by, say, jsmin.
  #--
  # TODO: combine Minifier and Renderer in a generic Renderer class with
  #       different strategies for various kinds of files.
  class Minifier

    # Item (stylesheet) to minify
    attr_accessor :item

    def initialize(item) #:nodoc:
      raise ArgumentError, 'Please provide an Asset subclass instance.' unless item.kind_of?(Asset)
      @item = item
    end

    # Generate and return the minified, optimized or otherwise processed
    # version of +item+'s +content+.
    def render
      case item
      when Stylesheet: render_stylesheet
      when Javascript: render_javascript
      end
    end

    # Shortcut-method to creating a new instance and calling +render+ on it.
    def self.render(*args)
      new(*args).render
    end

  private

    # TODO: minify, cache busters, validation, check images, etc.
    def render_stylesheet
      item.content
    end

    # TODO: minify, validate, requires, etc.
    def render_javascript
      item.content
    end
  end
end