module Laze
  module Store
    def self.[](kind)
      Base[kind]
    end

    class Base
      @children = {}

      class << self
        def inherited(child)
          @children[child.name.downcase.split(/::/).last.to_sym] = child
        end

        def for(kind)
          @children[kind].send(:new) rescue NoMethodError raise ChildNotFoundException
        end
        alias_method :[], :for

        private :new
      end

      include Enumerable
    end

    ChildNotFoundException = Class.new(Exception)
  end
end