$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

begin
  # Core
  require 'yaml'

  # Standard library
  require 'fileutils'

  # Third party
  require 'liquid'
  require 'maruku'
rescue LoadError
  # Gems
  retry if require 'rubygems'
  raise
end

# Internal requires
require 'laze/plugin'
require 'laze/item'
require 'laze/page'
require 'laze/section'
require 'laze/template'
require 'laze/secretary'
require 'laze/templates/liquid'
require 'laze/target'
require 'laze/target/filesystem'
require 'laze/store'
require 'laze/store/filesystem'

# Require all available plugins
Laze::Plugin.load_all

module Laze
  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end