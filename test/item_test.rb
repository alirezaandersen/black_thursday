require 'test_helper'
require 'item'
require 'bigdecimal'

class ItemTest < Minitest::Test
  attr_reader :c_time, :u_time
  def setup
    @c_time = Time.new(2016, 01, 04, 11, 27, 39, "-07:00")
    @u_time = Time.new(2016, 01, 25, 05, 12, 50, "-07:00")
  end

  def test_returns_the_name_of_an_item

    i = Item.new({ :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => BigDecimal.new(10.99,4),
      :created_at => c_time,
      :updated_at => u_time,
      :id => 932113,
      :merchant_id => 22145687})

      assert_equal "Pencil", i.name
  end

  def test_returns_item_description
    i = Item.new({ :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => BigDecimal.new(10.99,4),
      :created_at => c_time,
      :updated_at => u_time,
      :id => 932113,
      :merchant_id => 22145687})

      assert_equal "You can use it to write things", i.description
    end

    def test_returns_item_unit_price
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => c_time,
        :updated_at => u_time,
        :id => 932113,
        :merchant_id => 22145687})

        assert_equal 10.99, i.unit_price
        assert_kind_of BigDecimal, i.unit_price
    end

    def test_return_item_created_time
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => c_time,
        :updated_at => u_time,
        :id => 932113,
        :merchant_id => 22145687})

        assert i.created_at.kind_of?(Time)
    end

    def test_return_item_created_time
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => c_time,
        :updated_at => u_time,
        :id => 932113,
        :merchant_id => 22145687})

        assert i.updated_at.kind_of?(Time)
    end

    def test_item_can_return_an_ID_number
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => c_time,
        :updated_at => u_time,
        :id => 932113,
        :merchant_id => 22145687})

        assert_equal 932113, i.id
    end

    def test_item_can_return_a_merchant_ID_number
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => c_time,
        :updated_at => u_time,
        :id => 932113,
        :merchant_id => 22145687})

        assert_equal 22145687, i.merchant_id
    end
end
