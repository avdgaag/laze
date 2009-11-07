module Laze
  class Template

    attr_accessor :page

    @template_languages = {}

    class << self

      attr_reader :template_languages

      private :new

      def define(language_name, &block)
        p = new
        p.instance_eval(&block)
        template_languages[language_name] = p
        p
      end

      def for(language_name, page)
        templater = @template_languages[language_name]
        templater.page = page
        templater
      end
    end
  end
end