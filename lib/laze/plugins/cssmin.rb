begin
  require 'cssmin'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      # This plugin minifies the output of your CSS files, reducing your
      # website's bandwidth usage.
      #
      # This plugin is a decorator for StylesheetRenderer and fires after
      # StylesheetRenderer#render.
      #
      # *Note*: when the cssmin gem is unavailable this plugin will quietly
      # fail, leaving the .css files untouched and generating a warning in the
      # logs.
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