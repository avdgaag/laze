module Laze
  module Renderers
    class StylesheetRenderer < Renderer
      def initialize(page)
        raise ArgumentError unless page.is_a?(Stylesheet)
        super
      end

      # TODO: minify, cache busters, validation, check images, etc.
      def render(locals = {})
        string
      end
    end
  end
end