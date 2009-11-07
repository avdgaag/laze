$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

begin
  # Core
  require 'yaml'

  # Standard library

  # Third party
  require 'liquid'
rescue LoadError
  # Gems
  retry if require 'rubygems'
  raise
end

# Internal requires
require 'laze/layout'
require 'laze/item'
require 'laze/template'
require 'laze/secretary'
require 'laze/templates/liquid'

module Laze
  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end