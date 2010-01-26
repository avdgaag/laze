begin
  require 'less'
  module Laze #:nodoc:
    module Plugins #:nodoc:
      # This plugin parses stylesheets written in Less to normal CSS files.
      # The filename extension is converted to end in .css.
      #
      # See http://lesscss.org for more information.
      #
      # *Note*: when the less gem is unavailable this plugin will quietly fail,
      # leaving the .less files untouched and generating a warning in the
      # logs.
      module Less
        def self.applies_to?(kind) #:nodoc:
          kind == :stylesheet
        end

        # Parse the contents of the file with Less if the original filename
        # ends with <tt>.less</tt>
        def content
          return super unless properties[:filename] =~ /\.less$/
          @less_content ||= ::Less.parse(super)
        end

        # Overrides a stylesheet's filename to replace .less with .css, so
        # that <tt>screen.less</tt> becomes <tt>screen.css</tt>
        def filename
          super.sub(/\.less$/, '.css')
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The Less gem is required to convert .less files.'
end