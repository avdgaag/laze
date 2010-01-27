require 'helper'

class TestTarget < Test::Unit::TestCase
  context "all targets" do
    setup do
      FileUtils.stubs(:mkdir).returns(true)
      Laze::Plugins.stubs(:each)
    end

    context "generic target" do
      should 'return raise when no suitable child is found' do
        assert_raise(Target::TargetException) { Target.find(:foo) }
      end

      should 'raise when trying to create or save' do
        assert_raise(RuntimeError) { Target.new('output').create('foo') }
        assert_raise(RuntimeError) { Target.new('output').save }
      end

      should 'return suitable strategy' do
        assert_kind_of(Target, Target.find(:filesystem).new('...'))
      end
    end

    context "filesystem target" do
      setup do
        @t = Target.find(:filesystem)
      end

      should "create without errors" do
        @t.new('output')
      end

      context "creating an item" do
        setup do
          @t = Target.find(:filesystem).new('output')
          @p = Item.new({:path => 'xyz', :filename => 'foo'}, 'bar')
        end

        should "render the item" do
          f = mock()
          f.expects(:write).with('bar')
          File.expects(:open).with('output/xyz/foo', 'w').yields(f)
          @t.create(@p)
        end
      end

      context "creating a page" do
        setup do
          @t = Target.find(:filesystem).new('output')
          @p = Page.new({:filename => 'foo'}, 'bar')
        end

        should "render the page" do
          Renderer.expects(:render).with(@p).returns('bar')
          f = mock()
          f.expects(:write).with('bar')
          File.expects(:open).with('output/foo', 'w').yields(f)
          @t.create(@p)
        end
      end

      context "creating a section" do
        setup do
          @t = Target.find(:filesystem).new('output')
          FileUtils.expects(:mkdir).with('output/foo').returns(true)
        end

        should "description" do
          @t.create(Section.new({ :filename => 'foo' }))
        end

        should "create subitems for section" do
          a = Page.new({:filename => 'foo'}, 'bar')
          b = Section.new({:filename => 'foo'})
          b << a
          assert_equal(1, b.number_of_subitems)
          @t.expects(:create_page).with(a)
          @t.create(b)
        end
      end
    end
  end
end