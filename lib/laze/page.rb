module Laze
  class Page < Item
    include Laze::Plugin::Hookable

    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def to_s
      hook(:generate_page_content, self).content
    end
  end
end