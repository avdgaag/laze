module Laze
  module Plugins
    def self.each
      constants.each do |c|
        const = Laze::Plugins.const_get(c)
        yield const if const.is_a?(Module)
      end
    end
  end
end

# Load all plugins from /plugins
Dir[File.join(File.dirname(__FILE__), 'plugins', '*.rb')].each { |f| require f }