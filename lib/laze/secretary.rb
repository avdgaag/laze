module Laze
  class Secretary
    def self.run
      @target = Filesystem.new('output')
      Store[:filesystem].each do |item|
        @target.create item
      end
      'Done!'
    end
  end
end