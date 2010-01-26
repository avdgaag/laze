begin
  require 'less'
  module Laze
    module Plugins
      module Less
        def self.applies_to?(kind)
          kind == :stylesheet
        end

        def content
          content = super
          content = ::Less.parse(content) if properties[:filename] =~ /\.less$/
          content
        end

        def filename
          super.sub(/\.less$/, '.css')
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The Less gem is required to convert .less files.'
end