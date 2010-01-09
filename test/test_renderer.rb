require 'helper'

class TestRenderer < Test::Unit::TestCase
  context 'with bad options' do
    should 'raise an error with no arguments' do
      assert_raise(ArgumentError) { Renderer.new }
    end

    should 'raise an error with too many arguments' do
      assert_raise(ArgumentError) { Renderer.new(0, 1, 2) }
    end

    should "raise an error when not passed in a page or string" do
      assert_raise(ArgumentError) { Renderer.new(0) }
    end
  end

  context 'when creating' do
    should 'take a string and options' do
      renderer = Renderer.new('foo', { :bar => 'bar' })
      assert_equal('foo', renderer.string)
      assert_equal({ :bar => 'bar'}, renderer.options)
    end

    should 'default options to an empty hash' do
      assert_equal({}, Renderer.new('foo').options)
    end

    should 'take an page as string and options' do
      renderer = Renderer.new(Page.new({ :bar => 'bar'}, 'foo'))
      assert_equal('foo', renderer.string)
      assert_equal({ :locals => { :bar => 'bar' }}, renderer.options)
    end

    should "use the the shortcut class method to get the same result" do
      assert_equal(Renderer.new('foo').render, Renderer.render('foo'))
    end
  end

  context "when rendering" do
    setup do
      @page = Page.new({ :layout => 'foo' }, 'bar')
      @layout = Layout.new({}, 'layout: {{ yield }}')
      @renderer = Renderer.new(@page)
      Layout.expects(:find).with('foo').returns(@layout)
      Layout.expects(:find).with(nil).returns(nil)
    end

    should "wrap in layout" do
      assert_equal("layout: <p>bar</p>\n", @renderer.render)
    end

    should "take extra locals" do
      @renderer.expects(:liquify).with("layout: <p>bar</p>\n", { :layout => 'foo', :title => 'bla' })
      @renderer.render :title => 'bla'
    end
  end

end