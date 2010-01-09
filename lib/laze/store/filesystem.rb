module Laze
  module Store
    class Filesystem < Base
      def initialize
        Liquid::Template.file_system = LiquidFileSystem.new(Dir.pwd)
      end

      def each(start_dir = 'input', &block)
        scan_directory(start_dir, &block)
      end

      def layout(layout_name)
        filename = File.join('layouts', "#{layout_name}.html")
        raise LayoutNotFoundException.new(("Layout '%s.*' not found" % filename)) unless File.exists?(filename)
        content = FileWithMetadata.new(IO.read(filename))
      end

      LayoutNotFoundException = Class.new(Exception)

    private

      class LiquidFileSystem < Liquid::BlankFileSystem
        def initialize(root)
          @root = root
        end

        def read_template_file(template_path)
          filename = full_path(template_path)
          raise Liquid::FileSystemError, "No such template '#{filename}'" unless File.exists?(filename)
          File.read(filename)
        end

        def full_path(template_path)
          raise Liquid::FileSystemError, "Illegal template name '#{template_path}'" unless template_path =~ /^[^.\/][a-zA-Z0-9_\/]+$/

          full_path = if template_path.include?('/')
            File.join(@root, 'includes', File.dirname(template_path), "#{File.basename(template_path)}.html")
          else
            File.join(@root, 'includes', "#{template_path}.html")
          end

          raise Liquid::FileSystemError, "Illegal template path '#{File.expand_path(full_path)}'" unless File.expand_path(full_path) =~ /^#{File.expand_path(@root)}/

          full_path
        end

      end

      class FileWithMetadata
        attr_reader :content, :properties

        METADATA_SEPARATOR = /^---$\s*/

        def initialize(file_contents, extra_metadata = {})
          @file_contents, @properties = file_contents, extra_metadata
          split
        end

        def has?(key)
          properties.has_key?(key)
        end

      private

        def split
          @content = @file_contents
          if @file_contents =~ METADATA_SEPARATOR
            yaml_string, @content = @file_contents.split(METADATA_SEPARATOR, 2)
            @properties = yaml_string_to_properties(yaml_string).merge(@properties)
          end
        end

        def yaml_string_to_properties(yaml_string)
          properties = YAML.load(yaml_string)

          # TODO: move key symbolization into core extension
          properties = properties.inject({}) do |options, (key, value)|
            options[(key.to_sym rescue key) || key] = value
            options
          end
        end
      end

      def scan_directory(dirname)
        Dir.foreach(dirname) do |filename|
          # Skip directories
          next if %w[. ..].include?(filename)

          # Get current entry path
          path = File.join(dirname, filename)

          if File.file?(path)
            file = FileWithMetadata.new(IO.read(path), { :filename => filename })
            yield Page.new(file.properties, file.content)
          elsif File.directory?(path)
            section = Section.new({ :filename => filename })
            scan_directory(File.join(dirname, filename)) do |subitem|
              section << subitem
            end
            yield section
          end
        end
      end
    end
  end
end