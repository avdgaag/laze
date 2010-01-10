require 'helper'

class TestTarget < Test::Unit::TestCase
  should 'return raise when no suitable child is found' do
    assert_raise(Target::TargetException) { Target.find(:foo) }
  end

  should 'raise when trying to create' do
    assert_raise(RuntimeError) { Target.new.create('foo') }
  end

  should 'return suitable strategy' do
    assert_kind_of(Target, Target.find(:filesystem).new('...'))
  end
end