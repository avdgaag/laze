require 'fileutils'
require 'rr'
require 'test/unit'

World do
  include Test::Unit::Assertions
end

TEST_DIR    = File.join(ENV['PWD'], 'tmp')
LAZE_PATH = File.join(ENV['PWD'], 'bin', 'laze')

def run_laze(options = {})
  command = LAZE_PATH
  command << ' >> /dev/null 2>&1' if options[:debug].nil?
  system command
end