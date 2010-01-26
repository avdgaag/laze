begin
  require 'cssmin'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      module Cssmin
        def self.applies_to?(kind) #:nodoc:
          kind == 'Laze::Renderers::StylesheetRenderer'
        end

        def render(locals = {})
          return super unless Secretary.current.options[:minify_css]
          @minified_content = begin
            Laze.info "Minifying #{options[:locals][:filename]}"
            ::CSSMin.minify(super)
          end
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The cssmin gem is required to minify .css files.'
end