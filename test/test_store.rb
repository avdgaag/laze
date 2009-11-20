require 'helper'

class TestStore < Test::Unit::TestCase
  include Laze::Store
  should 'return raise when no suitable child is found' do
    assert_raise(ChildNotFoundException) { Base.for(:foo) }
  end

  should 'not be able to create' do
    assert_raise(NoMethodError) { Base.new }
  end

  should 'return suitable strategy' do
    assert_kind_of(Base, Base.for(:filesystem))
    assert_kind_of(Base, Base[:filesystem])
  end
end