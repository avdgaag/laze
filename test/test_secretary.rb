require 'helper'

class TestSecretary < Test::Unit::TestCase
  context 'singleton' do
    should 'keep track of the single instance' do
      s = Secretary.new
      assert_equal(Secretary.current, s)
    end
  end

  context 'creation withouth laze.yml' do
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

  context "creation with laze.yml" do
    setup do
      File.expects(:exists?).with('laze.yml').returns(true)
      YAML.expects(:load_file).with('laze.yml').returns({ :store => 'foo', :target => 'foo' })
      @s = Secretary.new({ :target => 'bar' })
    end

    should "override defaults with yaml settings" do
      assert_equal('foo', @s.options[:store])
    end

    should "override yaml settings with inline options" do
      assert_equal('bar', @s.options[:target])
    end
  end

end