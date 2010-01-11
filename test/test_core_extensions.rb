require 'helper'

class TestCoreExtensions < Test::Unit::TestCase
  context "hashes" do
    setup do
      @a = { 'foo' => 'bar' }
      @b = { :foo => 'bar' }
    end

    should "convert keys to strings" do
      assert_equal(@a, @b.stringify_keys)
    end

    should "convert keys to symbols" do
      assert_equal(@b, @a.symbolize_keys)
    end
  end

end