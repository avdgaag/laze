module Laze
  module Store
    class Filesystem < Base
      def each(start_dir = 'input', &block)
        scan_directory(start_dir, &block)
      end

    private

      def scan_directory(dirname)
        Dir.foreach(dirname) do |filename|
          # Skip directories
          next if %w[. ..].include?(filename)

          # Get current entry path
          path = File.join(dirname, filename)

          if File.file?(path)
            yield Page.new({ :filename => filename }, IO.read(path))
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