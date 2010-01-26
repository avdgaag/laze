module Laze
  module Plugins
    module Robots
      def self.applies_to?(kind)
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