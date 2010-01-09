require 'helper'

class TestLayout < Test::Unit::TestCase
  context "when creating" do
    should "store content" do
      assert_equal('foo', Layout.new({}, 'foo').content)
    end
  end

  context "instance" do
    setup do
      @layout = Layout.new({ :layout => 'foo' }, 'bar: {{ yield }}')
    end

    should "return its layout" do
      assert_equal('foo', @layout.layout)
    end

    should "wrap itself around a string" do
      assert_equal("bar: baz", @layout.wrap('baz'))
    end
  end
end