require 'test_helper'
require 'item'
require 'bigdecimal'

class ItemTest < Minitest::Test


  def test_returns_the_name_of_an_item
    i = Item.new({ :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => BigDecimal.new(10.99,4),
      :created_at => "2016-01-13 14:12:50 -0700",
      :updated_at => "2016-01-13 14:12:50 -0700",
      :id => 932113,
      :merchant_id => 22145687})

      assert_equal "Pencil", i.name
  end

  def test_returns_item_description
    i = Item.new({ :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => BigDecimal.new(10.99,4),
      :created_at => "2016-01-13 14:12:50 -0700",
      :updated_at => "2016-01-13 14:12:50 -0700",
      :id => 932113,
      :merchant_id => 22145687})

      assert_equal "You can use it to write things", i.description
    end

    def test_returns_item_unit_price
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => "2016-01-13 14:12:50 -0700",
        :updated_at => "2016-01-13 14:12:50 -0700",
        :id => 932113,
        :merchant_id => 22145687})

        assert_equal 10.99, i.unit_price
    end

    def test_return_item_created_time
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => "2016-01-13 14:12:50 -0700",
        :updated_at => "2016-01-13 14:12:50 -0700",
        :id => 932113,
        :merchant_id => 22145687})

        assert i.created_at.kind_of?(Time)
    end

    def test_return_item_created_time
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => "2016-01-13 14:12:50 -0700",
        :updated_at => "2016-01-13 14:12:50 -0700",
        :id => 932113,
        :merchant_id => 22145687})

        assert i.updated_at.kind_of?(Time)
    end

    def test_item_can_return_an_ID_number
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => "2016-01-13 14:12:50 -0700",
        :updated_at => "2016-01-13 14:12:50 -0700",
        :id => 932113,
        :merchant_id => 22145687})

        assert_equal 932113, i.id
    end

    def test_item_can_return_a_merchant_ID_number
      i = Item.new({ :name => "Pencil",
        :description => "You can use it to write things",
        :unit_price => BigDecimal.new(10.99,4),
        :created_at => "2016-01-13 14:12:50 -0700",
        :updated_at => "2016-01-13 14:12:50 -0700",
        :id => 932113,
        :merchant_id => 22145687})

        assert_equal 22145687, i.merchant_id
    end


end
