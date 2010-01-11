require 'helper'

class TestItemPageAndSection < Test::Unit::TestCase
  context "with children" do

    setup do
      @x = Page.new({ :title => 'x', :filename => 'foo' }, 'page x')
      @y = Page.new({ :title => 'y' }, 'page y')
      @z = Page.new({ :title => 'z' }, 'page z')
      @a = Section.new({ :title => 'a' })
      @b = Section.new({ :title => 'b' })
      @a.add_item @x
      @b.add_item @y
      @b.add_item @z
      @a.add_item @b
    end

    should "tell it has a property" do
      assert @x.has?(:title)
      assert !@x.has?(:foo)
    end

    should "inspect nicely" do
      assert_match(/#<Laze::Page:0x\w+? foo>/, @x.inspect)
    end

    should "tell its filename" do
      assert_equal('foo', @x.filename)
      assert_equal(@x.filename, @x.properties[:filename])
    end

    should "convert to string by its filename" do
      assert_equal('foo', @x.to_s)
    end

    should 'have subitems' do
      assert_equal(4, @a.number_of_subitems)
    end

    should "remove subitems" do
      assert_equal(3, @a.remove_item(@x).number_of_subitems)
      assert_nil(@x.parent)
    end

    should "enumerate over subitems" do
      i = 0
      @b.each do |item|
        assert_kind_of(Item, item)
        i += 1
      end
      assert_equal(2, i)
    end

    should "count the number of ancestors" do
      assert_equal(2, @y.ancestors.size)
      assert_equal(0, @a.ancestors.size)
    end
  end
end