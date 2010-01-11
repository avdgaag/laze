require 'helper'

class TestSecretary < Test::Unit::TestCase
  context 'singleton' do
    should 'keep track of the single instance' do
      s = Secretary.new
      assert_equal(Secretary.current, s)
    end
  end

  context 'creation' do
    setup do
      @s = Secretary.new({})
    end

    should 'use default options' do
      assert_not_nil(@s.options)
      assert_equal(:filesystem, @s.options[:store])
    end

    should 'keep track of current store and target' do
      assert_kind_of(Store, @s.store)
      assert_kind_of(Target, @s.target)
    end

    should 'cache current store and target' do
      Store.expects(:find).once.returns(Stores::Filesystem)
      2.times { assert_instance_of(Stores::Filesystem, @s.store) }
    end
  end
end