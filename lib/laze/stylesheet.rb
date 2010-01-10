module Laze
  # A special Item aimed at Cascading Stylesheets (CSS-files)
  class Stylesheet < Asset
    def filename
      @filename ||= properties[:filename].sub(/(?:less)$/, 'css')
    end
  end
end