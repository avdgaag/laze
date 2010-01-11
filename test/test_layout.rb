require 'helper'

class TestLayout < Test::Unit::TestCase
  context "when creating" do
    should "store content" do
      assert_equal('foo', Layout.new({}, 'foo').content)
    end

    should "return nil for a nil layout" do
      assert_nil(Layout.find(nil))
    end

    should "ask secretary for a layout" do
      store = mock()
      store.expects(:find_layout).with('foo').returns('bar')
      Secretary.expects(:store).returns(store)
      assert_equal('bar', Layout.find('foo'))
    end
  end

  context "simple layout" do
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

  context "complex layout" do
    setup do
      @layout = Layout.new({ :layout => 'foo' }, "bar\n    {{ yield }}\n")
    end

    should "preserve whitespace indent" do
      assert_equal("bar\n    foo", @layout.wrap('foo'))
    end
  end

end