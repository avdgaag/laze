module Laze
  class Renderer
    attr_reader :options, :string

    def initialize(*args)
      raise ArgumentError unless args.any?

      if args[0].is_a?(Page)
        @string = args[0].content
        @options = { :locals => args[0].properties }
      else
        @string, @options = args[0], args[1]
      end
    end

    def to_s(locals = {})
      output = markdownize(string)
      output = liquify(output, (options[:locals] || {}).merge(locals))
      output
    end
    alias_method :render, :to_s

    def self.render(*args)
      new(*args).render
    end

  private

    # TODO: take options for output
    def markdownize(string)
      Maruku.new(string).to_html
    end

    # TODO: take options for output
    def liquify(string, locals = {})
      Liquid::Template.parse(string).render('page' => stringify_keys(locals))
    end

    def stringify_keys(hash)
      hash.inject({}) do |options, (key, value)|
        options[key.to_s] = value
        options
      end
    end
  end
end