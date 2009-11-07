module Laze
  module Layoutable

    attr_accessor :layout

    def wrapped_in_layout
      layout.nil? ? content : layout.wrap(content)
    end

    def wrap(text)
      self.wrapped_in_layout.gsub(/\{\{\s*yield\s*\}\}/, content)
    end
  end
end