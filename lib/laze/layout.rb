module Laze
  class Layout

    module Layoutable

      attr_accessor :layout

      def wrapped_in_layout
        layout.nil? ? content : layout.wrap(content)
      end

      def wrap(text)
        self.wrapped_in_layout.gsub(/\{\{\s*yield\s*\}\}/, content)
      end
    end
    include Layoutable

    attr_accessor :content

    def initialize(content, layout = nil)
      @content, @layout = content, layout
    end
  end
end