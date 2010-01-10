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

  def debug(msg)
    LOGGER.debug(msg)
  end

  def warn(msg)
    LOGGER.warn(msg)
  end

  def info(msg)
    LOGGER.info(msg)
  end

  def fatal(msg)
    LOGGER.fatal(msg)
  end

  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end

  extend self
end

# Internal requires
require 'laze/core_extensions'
require 'laze/item'
require 'laze/page'
require 'laze/asset'
require 'laze/stylesheet'
require 'laze/javascript'
require 'laze/renderer'
require 'laze/section'
require 'laze/minifier'
require 'laze/layout'
require 'laze/secretary'
require 'laze/target'
require 'laze/targets/filesystem'
require 'laze/store'
require 'laze/stores/filesystem'