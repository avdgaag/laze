begin
  require 'jsmin'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      module Jsmin
        def self.applies_to?(kind) #:nodoc:
          kind == 'Laze::Renderers::StylesheetRenderer'
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