$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# Gems
require 'rubygems'

# Core
require 'yaml'

# Standard library

# Third party
require 'liquid'

# Internal requires
require 'laze/layoutable'
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