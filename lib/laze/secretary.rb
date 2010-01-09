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
        Laze.log "Processing #{item}"
        Target[@options[:target], @options[:directory]].create item
      end

      Laze.log 'Done!'
    end
  end
end