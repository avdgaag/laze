module Laze
  class Stylesheet < Asset
    def filename
      @filename ||= properties[:filename].sub(/(?:less)$/, 'html')
    end
  end
end