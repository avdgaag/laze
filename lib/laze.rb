$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

begin
  # Core
  require 'yaml'

  # Standard library
  require 'fileutils'
  require 'logger'

  # Third party
  require 'liquid'
  require 'rdiscount'
rescue LoadError
  # Gems
  retry if require 'rubygems'
  raise
end

module Laze
  LOGGER = Logger.new(STDERR)
  LOGGER.level = Logger::DEBUG
  LOGGER.datetime_format = "%H:%M:%S"

  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end

# Internal requires
require 'laze/core_extensions'
require 'laze/item'
require 'laze/page'
require 'laze/renderer'
require 'laze/section'
require 'laze/layout'
require 'laze/secretary'
require 'laze/target'
require 'laze/target/filesystem'
require 'laze/store'
require 'laze/stores/filesystem'