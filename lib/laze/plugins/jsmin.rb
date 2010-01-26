begin
  require 'jsmin'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      module Jsmin
        def self.applies_to?(kind) #:nodoc:
          kind == :javascript
        end

        def content
          @minified_content = begin
            Laze.info "Minifying #{filename}"
            ::JSMin.minify(super)
          end
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The jsmin gem is required to minify .js files.'
end