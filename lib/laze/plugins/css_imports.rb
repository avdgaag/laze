module Laze #:nodoc:
  module Plugins #:nodoc:
    # This plugin will replace any import statements in your stylesheets with
    # the actual contents of the referenced files. This reduces the number
    # of HTTP requests and speeds up your website loading time.
    #
    # This plugin is a decorator for Target and fires before Target#save.
    module CssImports
      def self.applies_to?(kind) #:nodoc:
        kind == :target
      end

      def save
        expand_css_imports
        super
      end

    private

      def expand_css(content, filename)
        Laze.info("Expanding imports in #{filename}")
        content.gsub!(/@import\s*url\(\s*('|")?\s*(.+)\s*\1?\s*\);?/) do |match|
          referenced_file = File.expand_path(File.join(File.dirname(filename), $2))
          if File.exists?(referenced_file)
            "/* #{match} */\n" + expand_css(File.read(referenced_file), referenced_file)
          else
            Laze.warn "CSS Imported file not found: #{referenced_file}"
            match
          end
        end
        content
      end

      def expand_css_imports
        Dir[File.join(output_dir, '**', '*.css')].each do |filename|
          content = File.read(filename)
          File.open(filename, 'w') { |f| f.write expand_css(content, filename) }
        end
      end
    end
  end
end