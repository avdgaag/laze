module Laze
  module Target
    def self.[](kind, *args)
      Base[kind, *args]
    end

    class Base
      @children = {}
      @instances = {}

      class << self
        def inherited(child)
          @children[child.name.downcase.split(/::/).last.to_sym] = child
        end

        def for(kind, *args)
          @instances[kind] ||= @children[kind].send(:new, *args) rescue NoMethodError raise ChildNotFoundException
        end
        alias_method :[], :for

        private :new
      end

      include Enumerable
    end

    ChildNotFoundException = Class.new(Exception)
  end
end