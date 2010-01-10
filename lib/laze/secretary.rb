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

    def self.store
      @store ||= Store.find(@options[:store]).new
    end

    def self.target
      @target ||= Target.find(@options[:target]).new(@options[:directory])
    end

    def self.run(options = {})
      @options = @options.merge(options)

      store.each do |item|
        target.create item
      end

      Laze.info 'Done!'
    end
  end
end