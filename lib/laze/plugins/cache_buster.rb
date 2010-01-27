module Laze #:nodoc:
  module Plugins #:nodoc:
    # This plugin applies cache busters to CSS files, Javascript files and
    # image files in your stylesheets. This means it will append the last
    # modified time of these referenced files to the URL references as
    # query parameters, so you force the server to bypass caches and give
    # you a new file when a file has changed.
    #
    # Example:
    #
    #   # css file
    #   body {
    #     background: url(image.png);
    #   }
    #
    #   # HTML file
    #   <link href="screen.css">
    #
    # Becomes:
    #
    #   # css file
    #   body {
    #     background: url(image.png?201009231441);
    #   }
    #
    #   # HTML file
    #   <link href="screen.css?201009231441">
    #
    module CacheBuster
      def self.applies_to?(kind) #:nodoc:
        kind == 'Laze::Renderers::PageRenderer' || kind == 'Laze::Renderers::StylesheetRenderer'
      end

      def render(locals = {})
        Laze.info("Adding cache busters to #{options[:locals][:filename]}")
        [ /((?:href|src)=(?:'|"))(.+\.(?:css|js))("|')/,
          /(url\([\s"']*)([^\)"'\s]*\.(?:png|gif|jpg))([\s"']*\))/m
        ].inject(super) do |output, regex|
          output.gsub(regex) do |match|
            filename = File.expand_path(File.join('input', options[:locals][:path], $2))
            output = "#{$1}#{$2}%s#{$3}"
            cache_buster = File.exists?(filename) ? '?' + File.mtime(filename).strftime('%Y%m%d%H%M') : ''
            output % cache_buster
          end
        end
      end
    end
  end
end