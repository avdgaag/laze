module Laze
  module Plugins
    module CacheBuster
      def self.applies_to?(kind)
        kind == 'Laze::Renderers::PageRenderer' || kind == 'Laze::Renderers::StylesheetRenderer'
      end

      def render(locals = {})
        Laze.info("Adding cache busters to #{options[:locals][:filename]}")
        [ /((?:href|src)=(?:'|"))(.+\.(?:css|js))("|')/,
          /(url\([\s"']*)([^\)"'\s]*)([\s"']*\))/m
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