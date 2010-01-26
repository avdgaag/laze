module Laze
  class Asset < Item # :nodoc:
    def filename
      properties[:filename]
    end
  end
end