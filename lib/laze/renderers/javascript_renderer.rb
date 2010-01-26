module Laze
  module Renderers #:nodoc:
    # Render javascript source files to output files. Does nothing right now,
    # just output the javascript directly.
    class JavascriptRenderer < Renderer
      def initialize(page) #:nodoc:
        raise ArgumentError unless page.is_a?(Javascript)
        super
      end

      def render(locals = {})
        string
      end
    end
  end
end