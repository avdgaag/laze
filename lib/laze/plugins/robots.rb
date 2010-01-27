module Laze #:nodoc:
  module Plugins #:nodoc:
    # This plugin creates a very simple robots.txt file with a reference
    # to the sitemap.
    #--
    # TODO: check to make sure there is not already a robots.txt
    # TODO: auto-build the file based on properties in the pages.
    module Robots
      # This plugin is a decorator for Target and fires before Target#save.
      def self.applies_to?(kind) #:nodoc:
        kind == :target
      end

      def save
        create_robots_txt
        super
      end

    private

      def create_robots_txt
        File.open(File.join(output_dir, 'robots.txt'), 'w') do |f|
          f.write 'Sitemap: sitemap.xml'
        end
      end
    end
  end
end