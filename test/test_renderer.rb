require 'helper'

class TestRenderer < Test::Unit::TestCase
  context 'with bad options' do
    should 'raise an error with no arguments' do
      assert_raise(ArgumentError) { Renderer.new }
    end

    should 'raise an error with too many arguments' do
      assert_raise(ArgumentError) { Renderer.new(0, 1, 2) }
    end

    should "raise an error when not passed in an item or string" do
      assert_raise(ArgumentError) { Renderer.new(0) }
      assert_nothing_raised(ArgumentError) { Renderer.new(Page.new({}, 'foo')) }
      assert_nothing_raised(ArgumentError) { Renderer.new('foo', {}) }
    end

    should "raise an error when using the generic class" do
      assert_raise(RuntimeError) { Renderer.new('foo', {}).render }
    end
  end

  context 'when creating' do
    should 'take a string and options' do
      renderer = Renderer.new('foo', { :bar => 'bar' })
      assert_equal('foo', renderer.string)
      assert_equal({ :locals => { :bar => 'bar' }}, renderer.options)
    end

    should 'take a page as string and options' do
      renderer = Renderer.new(Page.new({ :bar => 'bar'}, 'foo'))
      assert_equal('foo', renderer.string)
      assert_equal({ :locals => { :bar => 'bar' }}, renderer.options)
    end
  end

  should "render a stylesheet" do
    s = Stylesheet.new({ :filename => 'foo.css' }, 'foo')
    x = Renderers::StylesheetRenderer.new(s)
    x.expects(:render).returns('foo')
    Renderers::StylesheetRenderer.expects(:new).at_least_once.returns(x)
    Renderer.render(s)
  end

  should "render a javascript" do
    s = Javascript.new({ :filename => 'foo.js' }, 'foo')
    x = Renderers::JavascriptRenderer.new(s)
    x.expects(:render).returns('foo')
    Renderers::JavascriptRenderer.expects(:new).at_least_once.returns(x)
    Renderer.render(s)
  end

  context "when rendering a page" do
    setup do
      @page = Page.new({ :layout => 'foo' }, 'bar')
      @layout = Layout.new({}, 'layout: {{ yield }}')
      Layout.expects(:find).with('foo').returns(@layout)
      Layout.expects(:find).with(nil).returns(nil)
    end

    should "wrap in layout" do
      assert_equal("layout: <p>bar</p>\n", Renderer.render(@page))
    end

    should "take extra locals" do
      Renderers::PageRenderer.any_instance.expects(:liquify).with("layout: <p>bar</p>\n", { :layout => 'foo', :title => 'bla' }).returns('foo')
      Renderer.render(@page, :title => 'bla')
    end
  end
end