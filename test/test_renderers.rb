require "helper"

class TestRenderers < Test::Unit::TestCase
  include Laze::Renderers
  context "stylesheets" do
    setup do
      @stylesheet = Stylesheet.new({ :filename => 'test' }, 'foo')
    end

    should "not create without stylesheet" do
      assert_raise(ArgumentError) { StylesheetRenderer.new }
      assert_raise(ArgumentError) { StylesheetRenderer.new(0) }
      assert_raise(ArgumentError) { StylesheetRenderer.new(Page.new({}, '')) }
      assert_nothing_raised(ArgumentError) { StylesheetRenderer.new(@stylesheet) }
    end

    should "output content directly" do
      assert_equal('foo', StylesheetRenderer.new(@stylesheet).render)
    end
  end

  context "javascripts" do
    setup do
      @javascript = Javascript.new({ :filename => 'test' }, 'foo')
    end

    should "not create without javascript" do
      assert_raise(ArgumentError) { JavascriptRenderer.new }
      assert_raise(ArgumentError) { JavascriptRenderer.new(0) }
      assert_raise(ArgumentError) { JavascriptRenderer.new(Page.new({}, '')) }
      assert_nothing_raised(ArgumentError) { JavascriptRenderer.new(@javascript) }
    end

    should "output content directly" do
      assert_equal('foo', JavascriptRenderer.new(@javascript).render)
    end
  end
end