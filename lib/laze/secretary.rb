module Laze
  class Secretary
    @options = {
      :store     => :filesystem,
      :target    => :filesystem,
      :directory => 'output'
    }

    def self.options
      @options
    end

    def self.run(options = {})
      @options = @options.merge(options)

      Store[@options[:store]].each do |item|
        Target[@options[:target], @options[:directory]].create item
      end

      'Done!'
    end
  end
end