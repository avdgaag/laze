module Laze
  module Plugins
    module CssImports
      def self.applies_to?(kind)
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