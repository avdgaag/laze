begin
  require 'cssmin'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      module Cssmin
        def self.applies_to?(kind) #:nodoc:
          kind == :stylesheet
        end

        def content
          @minified_content = begin
            Laze.info "Minifying #{filename}"
            ::CSSMin.minify(super)
          end
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The cssmin gem is required to minify .css files.'
end