module Laze
  # A special kind of Item aimed at HTML files (could be files ending in
  # html, htm, md, mkd, mdn, markdown or liquid).
  class Page < Item
    attr_accessor :content

    def initialize(properties, content)
      @content = content
      super(properties)
    end

    def filename
      @filename ||= properties[:filename].sub(/(?:md|mkd|liquid|markdown|htm)$/, 'html')
    end
  end
end