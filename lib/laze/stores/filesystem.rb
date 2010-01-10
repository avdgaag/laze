module Laze
  module Stores
    class Filesystem < Store
      INCLUDES_DIR = 'includes'
      LAYOUTS_DIR  = 'layouts'
      INPUT_DIR    = 'input'

      def initialize(root = Dir.pwd)
        @root = root
      end

      def each(&block)
        scan_directory(File.join(@root, INPUT_DIR), &block)
      end

      def find_layout(layout_name)
        FileWithMetadata.new(read_template_file(layout_name, LAYOUTS_DIR)).to_layout
      end

      def read_template_file(include_name, from_dir = INCLUDES_DIR)
        raise FileSystemException, "Illegal filename '#{include_name}'" unless include_name =~ /^[^.\/][a-zA-Z0-9_\/]+$/
        full_path = File.join(@root, from_dir, "#{include_name}.html")
        raise FileSystemException, "Illegal template path '#{File.expand_path(full_path)}'" unless File.expand_path(full_path) =~ /^#{File.expand_path(@root)}/
        File.read(full_path)
      end

    private

      def scan_directory(path)
        Laze::LOGGER.debug "Recursing into #{path}"

        Dir.foreach(path) do |filename|
          # Skip directories
          next if %w[. ..].include?(filename)

          # Get current entry path
          full_path = File.join(path, filename)

          if File.file?(full_path)
            Laze::LOGGER.debug "Processing file #{path}"
            yield FileWithMetadata.new(File.read(full_path), { :filename => filename }).to_page

          elsif File.directory?(full_path)
            section = Section.new({ :filename => filename })
            scan_directory(full_path) do |subitem|
              section << subitem
            end
            yield section

          else
            Laze::LOGGER.debug "Skipping #{path}"
          end
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

        def to_page
          Page.new(properties, content)
        end

        def to_layout
          Layout.new(properties, content)
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
          properties = YAML.load(yaml_string).symbolize_keys
        end
      end
    end
  end
end