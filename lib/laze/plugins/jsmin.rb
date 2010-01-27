begin
  require 'jsmin'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      # This plugin uses the jsmin gem to minify your javascript files
      # and thereby reduce your website's bandwidth usage.
      #
      # This plugin is a decorator for JavascriptRenderer and fires after
      # JavascriptRenderer#render.
      #
      # *Note*: when the jsmin gem is unavailable this plugin will quietly
      # fail, leaving the .js files untouched and generating a warning in the
      # logs.
      module Jsmin
        def self.applies_to?(kind) #:nodoc:
          kind == 'Laze::Renderers::JavascriptRenderer'
        end

        def render(locals = {})
          return super unless Secretary.current.options[:minify_js]
          @minified_content = begin
            Laze.info "Minifying #{options[:locals][:filename]}"
            ::JSMin.minify(super)
          end
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The jsmin gem is required to minify .js files.'
end