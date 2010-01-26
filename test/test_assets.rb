require 'helper'

class TestAssets < Test::Unit::TestCase
  context "generic asset" do
    should "take content and options" do
      asset = Asset.new({ :title => 'foo' }, 'bar')
      assert_equal({:title => 'foo'}, asset.properties)
      assert_equal('bar', asset.content)
    end

    should "return its filename" do
      asset = Asset.new({:filename => 'foo'}, 'bar')
      assert_equal('foo', asset.filename)
    end
  end

  context "stylesheet" do
    setup do
      @less_stylesheet = Stylesheet.new({ :filename => 'base.less' }, 'foo')
      @stylesheet      = Stylesheet.new({ :filename => 'base.css' }, 'foo')
    end

    should "convert the filename to css" do
      assert_equal('base.css', @less_stylesheet.filename)
      assert_equal('base.css', @stylesheet.filename)
    end
  end
end