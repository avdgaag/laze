module Laze
  # A layout is a special kind of file that can be used to remove duplication
  # of HTML boilerplate code. Store a header and footer of a page in a layout
  # and simply wrap that around a given piece of content to create a page.
  #
  # == Inserting content into a layout
  #
  # A layout can contain anything you like. The only rule is you should insert
  # an insertion point for the content of a page. Here's a simple example:
  #
  #   <html>
  #     <head>
  #       <title>My awesome website</title>
  #     </head>
  #     <body>
  #       {{ yield }}
  #     </body>
  #   </html>
  #
  # When your page's content is "Welcome" your resulting page output would be:
  #
  #   <html>
  #     <head>
  #       <title>My awesome website</title>
  #     </head>
  #     <body>
  #       Welcome
  #     </body>
  #   </html>
  #
  # Laze does its best to preserve whitespace in your content.
  #
  # == Nested templates
  #
  # You can nest multiple layouts, i.e. a layout can itself have a layout.
  # This way you can create a master template for your site, with
  # subtemplates for various page types.
  #
  # Simply give your layout file a layout like so:
  #
  #   layout: my_layout
  #   ---
  #   <html>
  #     <head>
  #       <title>My awesome website</title>
  #     </head>
  #     <body>
  #       {{ yield }}
  #     </body>
  #   </html>
  #
  # == Template data in layout files
  #
  # You can use any variables defined in your pages in your layouts, and
  # the other way around. You could, for example, include the page title in
  # your <tt><title></tt> element:
  #
  #   <html>
  #     <head>
  #       <title>{{ page.title }} - My awesome website</title>
  #     </head>
  #     <body>
  #       {{ yield }}
  #     </body>
  #   </html>
  #
  class Layout < Item

    # Regex matching where to insert a layout's content
    YIELD = /\{\{\s*yield\s*\}\}/

    # Special regex matching an insertion point on a single blank line. In
    # this case we can preserve whitespace indents.
    SINGLE_LINE_YIELD = /^(\s+)#{YIELD}\s*$/

    # Textual content of the layout.
    attr_accessor :content

    def initialize(properties, content) #:nodoc:
      @content = content
      super(properties)
    end

    # Apply this layout to a piece of text, returning this layout's content
    # with the +YIELD+ replacd with the given string.
    #
    # If the +YIELD+ is on a single line that is matched by +SINGLE_LINE_YIELD+
    # it will prefix every line in +string+ with the whitespace indent of the
    # +YIELD+.
    def wrap(string)
      if content =~ SINGLE_LINE_YIELD
        whitespace = $1
        content.sub(SINGLE_LINE_YIELD, string.split(/\n/).map { |l| whitespace + l }.join("\n"))
      else
        content.sub(YIELD, string)
      end
    end

    # Return this layout's own layout, to enable nested layouts. Simple
    # shortcut function.
    def layout
      properties[:layout]
    end

    # Use the currently active data store to look for a layout by a given
    # name. Returns +nil+ when given +nil+, and a new layout instance
    # otherwise.
    def self.find(layout_name)
      return unless layout_name
      Secretary.current.store.find_layout(layout_name)
    end
  end
end