module Laze
  module Renderers
    class PageRenderer < Renderer
      def initialize(page)
        raise ArgumentError unless page.is_a?(Page)
        super
      end

      # First apply markdown, only then wrap in layout. A layout that contains
      # HTML boiler plate stuff (<html>, <doctype>, etc) will get messed up
      # when markdownized.
      def render(locals = {})
        output = string
        output = markdownize(output)
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
      def markdownize(string)
        RDiscount.new(string).to_html
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