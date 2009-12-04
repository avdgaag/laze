module Laze
  module Store
    class Filesystem < Base
      include Laze::Plugin::Hookable

      def each(start_dir = 'input', &block)
        scan_directory(start_dir, &block)
      end

      def layouts
        Dir.entries('layouts') - %w{. ..}
      end

      def layout(filename)
        candidates = Dir['layouts/' + filename + '.*']

        raise LayoutNotFoundException.new(("Layout '%s.*' not found" % filename)) unless candidates.any?
        raise AmbiguousLayoutNameException.new("Could not decide between %s for layout '%s'" % [(candidates * ', '), filename]) unless candidates.size == 1

        content = FileWithMetadata.new(IO.read(candidates.first))
        hook(:filter_layout, content)
      end

      AmbiguousLayoutNameException = Class.new(Exception)
      LayoutNotFoundException = Class.new(Exception)

    private

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