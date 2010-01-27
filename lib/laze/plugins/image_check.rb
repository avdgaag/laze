module Laze #:nodoc:
  module Plugins #:nodoc:
    # This plugin checks your stylesheets for missing images and spits out
    # a log warning message when an image file referenced in your
    # stylesheets could not be found.
    #
    # This plugin is a decorator for StylesheetRenderer and fires after
    # StylesheetRenderer#render.
    module ImageCheck
      def self.applies_to?(kind) #:nodoc:
        kind == 'Laze::Renderers::StylesheetRenderer'
      end

      def render(locals = {})
        Laze.debug 'Checking for missing stylesheet images'
        super.scan(/url\(\s*('|")?\s*(.+?)\s*\1?\s*\)/) do |match|
          filename = match[1].split("?", 2).first
          if %w(.gif .png .jpg .jpeg).include?(File.extname(filename))
            path = File.expand_path(File.join(Secretary.current.options[:source], 'input', options[:locals][:path], filename))
            unless File.exists?(path)
              Laze.warn "Image #{path} not found (#{options[:locals][:filename]})."
            end
          end
        end
      end
    end
  end
end