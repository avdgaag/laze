module Laze
  class Renderer
    attr_reader :options, :string

    def initialize(*args)
      raise ArgumentError, 'Please provide a string to render.' unless args.any?
      raise ArgumentError, 'Please provide only a string to render and an options hash.' if args.size > 2
      raise ArgumentError, 'Please provide a string or a Laze::Page instance to render' unless args[0].is_a?(Page) || args[0].is_a?(String)

      if args[0].is_a?(Page)
        @string = args[0].content
        @options = { :locals => args[0].properties }
      else
        @string, @options = args[0], (args[1] || {})
      end
    end

    # First apply markdown, only then wrap in layout. A layout that contains
    # HTML boiler plate stuff (<html>, <doctype>, etc) will get messed up
    # when markdownized.
    def to_s(locals = {})
      output = string
      output = markdownize(output)
      output = wrap_in_layout(output)
      output = liquify(output, (options[:locals] || {}).merge(locals))
      output
    end
    alias_method :render, :to_s

    # Shortcut method to <tt>new(...).render</tt>
    def self.render(*args)
      new(*args).render
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