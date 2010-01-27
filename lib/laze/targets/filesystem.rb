module Laze
  module Targets #:nodoc:
    class Filesystem < Target

      # Manifest an item -- write it to disk
      def create(item)
        case item
        when Page, Asset: create_page(item)
        when Section: create_section(item)
        when Item: copy_file(item)
        end
      end

      def save
        # already done...
      end

    private

      def copy_file(item)
        File.open(File.join(output_dir, item.properties[:path], item.properties[:filename]), 'w') { |f| f.write item.content }
      end

      def create_page(item)
        File.open(dir(item), 'w') { |f| f.write Renderer.render(item) }
      end

      def create_section(item)
        FileUtils.mkdir(dir(item))
        item.each { |subitem| create(subitem) }
      end

      # Get the correct path for a given item.
      # This finds all the ancestors for an item, joins them together
      # as directories and returns the path name.
      def dir(item)
        File.join(output_dir, *(item.ancestors.map{ |i| i.filename } << item.filename))
      end
    end
  end
end