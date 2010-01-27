begin
  require 'builder'
  require 'zlib'
  module Laze  #:nodoc:
    module Plugins #:nodoc:
      # This plugin will generate a sitemap for your website after it has been
      # generated. It will scan for all HTML files in your output directory
      # and will collect these in a sitemap.xml file.
      #
      # This plugin will also create a gzipped sitemap in sitemap.xml.gz.
      #
      # This plugin is a decorator for Target and fires before Target#save.
      #
      # *Note*: when the builder or zlib gems are unavailable this plugin will
      # quietly fail, generating no sitemap files and generating a warning in
      # the logs.
      module Sitemap
        def self.applies_to?(kind) #:nodoc:
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