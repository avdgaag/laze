module Laze #:nodoc:
  module Plugins #:nodoc:
    # This plugin tries to optimize the images in your website.
    # You will need to have +pngcrush+ and +jpegtran+ installed on your
    # system for this plugin to work. If not, it will fail silently.
    #
    # This plugin is a decorator for Target and fires before Target#save.
    module ImageOptimizer
      def self.applies_to?(kind) #:nodoc:
        kind == :target
      end

      def save
        optimize_images
        super
      end

    private

      def optimize_images
        pngcrush = `which pngcrush`
        jpegtran = `which jpegtran`

        Laze.warn 'pngcrush not found; skipping PNG optimization' if pngcrush.empty?
        Laze.warn 'jpegtran not found; skipping JPG optimization' if jpegtran.empty?

        Dir[File.join(output_dir, '**/*.{png,jpg}')].each do |filename|
          temp_file = filename + '_optimized'
          if File.extname(filename).downcase == '.png' && !pngcrush.empty?
            optimize_png(filename, temp_file)
          elsif File.extname(filename).downcase == '.jpg' && !jpegtran.empty?
            optimize_jpg(filename, temp_file)
          end
          if File.exists?(temp_file)
            FileUtils.rm(filename)
            FileUtils.mv(temp_file, filename)
          end
        end
      end

      def optimize_png(filename, temp_file)
        Laze.info "Optimizing #{filename}"
        system("pngcrush -q -reduce -brute #{filename} #{temp_file}")
      end

      def optimize_jpg(filename, temp_file)
        Laze.info "Optimizing #{filename}"
        system("jpegtran -copy none -progressive -outfile #{temp_file} #{filename}")
      end
    end
  end
end