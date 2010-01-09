module Laze
  module Target
    class Filesystem < Base
      # The base directory to create all the files in. This is relative
      # the location where laze is run from.
      attr_reader :output_dir

      def initialize(output_dir)
        Laze::LOGGER.debug "Initialized Target::Filesystem"
        @output_dir = output_dir
        reset
      end

      # Manifest an item -- write it to disk
      def create(item)
        case item
        when Page: create_page(item)
        when Section: create_section(item)
        end
      end

    private

      def create_page(item)
        File.open(dir(item), 'w') { |f| f.write Renderer.render(item) }
      end

      def create_section(item)
        FileUtils.mkdir(dir(item))
        item.each { |subitem| create(subitem) }
      end

      # Empty the current output directory
      def reset
        FileUtils.rm_rf(@output_dir)
        FileUtils.mkdir(@output_dir)
        Laze::LOGGER.debug "Emptied output directory"
      end

      # Get the correct path for a given item.
      # This finds all the ancestors for an item, joins them together
      # as directories and returns the path name.
      def dir(item)
        File.join(@output_dir, *(item.ancestors.map{ |i| i.filename } << item.filename))
      end
    end
  end
end