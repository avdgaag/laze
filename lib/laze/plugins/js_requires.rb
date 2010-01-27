module Laze #:nodoc:
  module Plugins #:nodoc:
    # This plugin introduces the +require+ statement to your javascript files.
    # This is a simple mechanism to concatenate all your javascript files
    # into a single library and thereby reduce the number of HTTP requests
    # (improving your website load time).
    #
    # You can include another javascript file with a special comment like so:
    #
    #   # foo.js
    #   var foo = 'foo';
    #
    #   # bar.js
    #   // require 'foo.js'
    #   alert(foo);
    #
    # This will compile into the following file:
    #
    #   # bar.js
    #   var foo = 'foo';
    #   alert(foo);
    #
    # Note that this leaves the original files untouched, so your website
    # will end up with both files. The point is you only have to reference
    # the one with that is concatenated.
    #
    # This plugin is a decorator for Target and fires before Target#save.
    module JsRequires
      # This plugin is a decorator for Target and fires before Target#save.
      def self.applies_to?(kind) #:nodoc:
        kind == :target
      end

      def save
        expand_js_requires
        super
      end

    private

      def expand_js(content, filename)
        Laze.info("Expanding requires in #{filename}")
        content.gsub!(/^\s*\/\/\s*requires? ('|")?(.+)\1$/) do |match|
          referenced_file = File.expand_path(File.join(File.dirname(filename), $2))
          if File.exists?(referenced_file)
            "#{match}\n" + expand_js(File.read(referenced_file), referenced_file)
          else
            Laze.warn "JS required file not found: #{referenced_file}"
            match
          end
        end
        content
      end

      def expand_js_requires
        Dir[File.join(output_dir, '**', '*.js')].each do |filename|
          content = File.read(filename)
          File.open(filename, 'w') { |f| f.write expand_js(content, filename) }
        end
      end
    end
  end
end