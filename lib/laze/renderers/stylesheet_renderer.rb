module Laze
  module Renderers #:nodoc:
    # Render CSS source files to output files. Does nothing right now,
    # just output the CSS directly.
    class StylesheetRenderer < Renderer
      def initialize(page) #:nodoc:
        raise ArgumentError unless page.is_a?(Stylesheet)
        super
      end

      def render(locals = {})
        string
      end
    end
  end
end