require 'helper'

class TestStore < Test::Unit::TestCase
  should 'return raise when no suitable child is found' do
    assert_raise(Store::StoreException) { Store.find(:foo) }
  end

  should 'raise when trying to create' do
    store = Store.new
    %w{each read_template_file find_layout}.each do |method|
      assert_raise(RuntimeError) { store.send(method.to_sym) }
    end
  end

  should 'return suitable strategy' do
    assert_kind_of(Store, Store.find(:filesystem).new)
  end
end