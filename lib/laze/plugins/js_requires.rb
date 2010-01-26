module Laze
  module Plugins
    module JsRequires
      def self.applies_to?(kind)
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