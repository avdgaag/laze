$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

begin
  # Core
  require 'yaml'

  # Standard library
  require 'fileutils'

  # Third party
  require 'liquid'
  require 'rdiscount'
rescue LoadError
  # Gems
  retry if require 'rubygems'
  raise
end

# Internal requires
require 'laze/item'
require 'laze/page'
require 'laze/renderer'
require 'laze/section'
require 'laze/layout'
require 'laze/secretary'
require 'laze/target'
require 'laze/target/filesystem'
require 'laze/store'
require 'laze/store/filesystem'

module Laze
  def self.log(message)
    puts message
  end

  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end