begin
  require 'builder'
  require 'zlib'
  module Laze
    module Plugins
      module Sitemap
        def self.applies_to?(kind)
          kind == :target
        end

        def save
          create_and_deflate_sitemap(generate_sitemap)
          super
        end

      private

        def create_and_deflate_sitemap(sitemap)
          path = File.join(output_dir, 'sitemap.xml')
          Laze.debug 'Writing sitemap.xml'
          File.open(path, 'w') do |f|
            f.write sitemap
          end
          Laze.debug 'Writing sitemap.xml.gz'
          Zlib::GzipWriter.open(path + '.gz') do |gz|
              gz.write sitemap
          end
        end

        def generate_sitemap
          Laze.info 'Generating XML sitemap'
          sitemap = ''
          xml = Builder::XmlMarkup.new(:target => sitemap, :indent => 2)
          xml.instruct!
          xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') do
            Dir[File.join(output_dir, '**/*.html')].each do |page|
              Laze.debug "Including #{page}"
              xml.url do
                xml.loc(page.sub(output_dir, (Secretary.current.options[:domain]) || ''))
                xml.lastmod(File.mtime(page).strftime("%Y-%m-%dT%H:%M:%S+00:00"))
                xml.changefreq('weekly')
              end
            end
          end
          sitemap
        end
      end
    end
  end
rescue LoadError
  Laze.warn 'The builder and zlib gems are needed to generate sitemaps'
end