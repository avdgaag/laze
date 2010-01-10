module Laze
  # A special kind of Item aimed at HTML files (could be files ending in
  # html, htm, md, mkd, mdn, markdown or liquid).
  class Page < Item
    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    # Convert this page's content to HTML using a text filter. You can set
    # the text filter to use with a property +text_filter+.
    #
    # Current filters supported are markdown and none. Default is markdown.
    def filtered_content
      text_filter ? text_filter.new(content).to_html : content
    end

    def filename
      @filename ||= properties[:filename].sub(/(?:md|mkd|liquid|markdown|htm)$/, 'html')
    end

  private

    # Try to read the text filter to use from the properties. Return nil when
    # 'none' is defined, RDiscount when undefined or otherwise the
    # associated filter.
    def text_filter
      case properties[:filter]
      when 'markdown': RDiscount
      when 'none': nil
      else
        RDiscount
      end
    end
  end
end