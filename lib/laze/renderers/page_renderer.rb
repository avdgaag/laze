module Laze
  module Renderers #:nodoc:
    # Renders Page objects to an HTML page. This means applying text filters,
    # layouts and the Liquid templating engine to a source file and returning
    # the full HTML result file.
    class PageRenderer < Renderer
      def initialize(page) #:nodoc:
        raise ArgumentError unless page.is_a?(Page)
        super(page.filtered_content, page.properties)
      end

      # Apply layouts and the liquid templating language.
      def render(locals = {})
        liquify(wrap_in_layout(string), (options[:locals] || {}).merge(locals))
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

      def liquify(string, locals = {})
        Liquid::Template.parse(string).render('page' => locals.stringify_keys)
      end
    end
  end
end