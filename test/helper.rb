require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'laze'

Laze::LOGGER.level = Logger::FATAL

class Test::Unit::TestCase
  include Laze
end
