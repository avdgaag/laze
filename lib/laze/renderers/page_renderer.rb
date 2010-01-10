module Laze
  module Renderers #:nodoc:
    # Renders Page objects to an HTML page. This means applying text filters,
    # layouts and the Liquid templating engine to a source file and returning
    # the full HTML result file.
    #--
    # TODO: make the text filter to use optional and customizable, like
    #       markdown, textile, rdoc, etc.
    # TODO: move text filter into the page class, since its the page's
    #       responsibility what text filter to use.
    class PageRenderer < Renderer
      def initialize(page) #:nodoc:
        raise ArgumentError unless page.is_a?(Page)
        super(page.filtered_content, page.properties)
      end

      # First apply markdown, only then wrap in layout. A layout that contains
      # HTML boiler plate stuff (<html>, <doctype>, etc) will get messed up
      # when markdownized.
      def render(locals = {})
        output = string
        output = wrap_in_layout(output)
        output = liquify(output, (options[:locals] || {}).merge(locals))
        output
      end

    private

      def wrap_in_layout(content_to_wrap)
        # do nothing if there is no layout option
        return content_to_wrap unless options[:locals] && options[:locals][:layout]

        # do nothing if there is a layout option, but it can't be found
        return content_to_wrap unless layout = Layout.find(options[:locals][:layout])

        # Recursively wrap string in layout
        output = content_to_wrap
        while layout
          output = layout.wrap(output)
          layout = Layout.find(layout.layout)
        end
        output
      end

      # TODO: take options for output
      def liquify(string, locals = {})
        Liquid::Template.parse(string).render('page' => stringify_keys(locals))
      end

      # Convert { :foo => 'bar' } to { 'foo' => 'bar' }
      def stringify_keys(hash)
        hash.inject({}) do |options, (key, value)|
          options[key.to_s] = value
          options
        end
      end
    end
  end
end