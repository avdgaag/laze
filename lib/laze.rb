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
  require 'redcloth'
rescue LoadError
  # Gems
  retry if require 'rubygems'
  raise
end

module Laze #:nodoc:
  def debug(msg)
    LOGGER.debug(msg) if const_defined?('LOGGER')
  end

  def warn(msg)
    LOGGER.warn(msg) if const_defined?('LOGGER')
  end

  def info(msg)
    LOGGER.info(msg) if const_defined?('LOGGER')
  end

  def fatal(msg)
    LOGGER.fatal(msg) if const_defined?('LOGGER')
  end

  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end

  extend self
end

# Internal requires
require 'laze/core_extensions'
require 'laze/plugins'
require 'laze/item'
require 'laze/page'
require 'laze/asset'
require 'laze/stylesheet'
require 'laze/javascript'
require 'laze/renderer'
require 'laze/renderers/page_renderer'
require 'laze/renderers/stylesheet_renderer'
require 'laze/renderers/javascript_renderer'
require 'laze/section'
require 'laze/layout'
require 'laze/secretary'
require 'laze/target'
require 'laze/targets/filesystem'
require 'laze/store'
require 'laze/stores/filesystem'