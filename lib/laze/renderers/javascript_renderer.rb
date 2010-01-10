module Laze
  module Renderers
    class JavascriptRenderer < Renderer
      def initialize(page)
        raise ArgumentError unless page.is_a?(Javascript)
        super
      end

      # TODO: minify, validate, requires, etc.
      def render(locals = {})
        string
      end
    end
  end
end