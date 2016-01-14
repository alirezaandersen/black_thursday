require 'test_helper'
require 'sales_analyst'
require 'sales_engine'
require 'bigdecimal'
require 'mocha/mini_test'

class InternSalesAnalyst < Minitest::Test
  def test_analyst_can_get_average_items_per_merchant
    m1 = Merchant.new({:name => "Ali's glitter taphouse",
      :id => 356})
    m2 = Merchant.new({:name => "Erinna's dog spoiling services", :id => 743})
    i1 = Item.new({:name => "Rainbow blonde glitter ale",
      :description => "No explanation needed",
      :unit_price => BigDecimal.new(4.00, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 101})
    i2 = Item.new({:name => "Stripper glitter stout",
      :description => "Hearty and sparkley ABV 13.6\%",
      :unit_price => BigDecimal.new(7.50, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 102})

    i3 = Item.new({:name => "Glitter tail braids",
      :description => "For those flashy occasions",
      :unit_price => BigDecimal.new(23.00, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 743,
      :id => 201})
    i4 = Item.new({:name => "Diamond manicure",
      :description => "Be dazzling your paws",
      :unit_price => BigDecimal.new(15.50, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 743,
      :id => 202})
    i5 = Item.new({:name => "KimmyKs glitter collar",
      :description => "Channel your inner Kardashian",
      :unit_price => BigDecimal.new(9.95, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 743,
      :id => 203})
    i6 = Item.new({:name => "Sparkle cologne",
      :description => "Attract those bitches",
      :unit_price => BigDecimal.new(19.95, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 743,
      :id => 204})
    args = {items: [i1,i2,i3,i4,i5,i6], merchants: [m1,m2]}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 2, sa.sales_engine.merchants.all.length
    assert_equal 6, sa.sales_engine.items.all.length

    assert_equal 3, sa.average_items_per_merchant
  end

  def test_calculate_standard_deviation
    m1 = Merchant.new({:name => "M1", :id => 210})
    m2 = Merchant.new({:name => "M2", :id => 220})
    m3 = Merchant.new({:name => "M3", :id => 230})
    m4 = Merchant.new({:name => "M4", :id => 240})
    m5 = Merchant.new({:name => "M5", :id => 250})
    m1.stubs(:items).returns([1])
    m2.stubs(:items).returns([1])
    m3.stubs(:items).returns([1,1,1,1,1])
    m4.stubs(:items).returns([1,1,1,1,1,1])
    m5.stubs(:items).returns([1,1,1,1,1,1,1])
    args = {items: [], merchants: [m1,m2,m3,m4,m5]}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 4.00, sa.average_items_per_merchant
    assert_equal 2.83, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_low_item_count
    m1 = Merchant.new({:name => "M1", :id => 210})
    m2 = Merchant.new({:name => "M2", :id => 220})
    m3 = Merchant.new({:name => "M3", :id => 230})
    m4 = Merchant.new({:name => "M4", :id => 240})
    m5 = Merchant.new({:name => "M5", :id => 250})
    m1.stubs(:items).returns([1])
    m2.stubs(:items).returns([1])
    m3.stubs(:items).returns([1]*7)
    m4.stubs(:items).returns([1]*8)
    m5.stubs(:items).returns([1]*10)
    args = {items: [], merchants: [m1,m2,m3,m4,m5]}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 5.40, sa.average_items_per_merchant
    assert_equal 4.16, sa.average_items_per_merchant_standard_deviation
    assert_equal [m1, m2], sa.merchants_with_low_item_count
  end

end


class SalesAnalystTest < Minitest::Test

  def test_Analyst_has_a_SalesEngine
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    assert_kind_of SalesEngine, sa.sales_engine
  end

  def test_average_items_per_merchant
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal 2.88, sa.average_items_per_merchant
  end

  def test_can_calculate_the_standard_deviation_of_items_per_merchant
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_average_price_for_merchant
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal 12875, sa.average_item_price_for_merchant(12334738).round(0)
  end

  def test_average_price_per_merchant
    skip
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal 72251,
    sa.average_price_per_merchant.to_f.round(0)
  end

  def test_merchants_can_have_golden_items
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    gold_items = sa.golden_items
    assert_equal 5, gold_items.length
    assert_equal "Solid American Black Walnut Trestle Table", gold_items[4].name
    assert gold_items.all? {|item| item.unit_price > 659851.0}
  end

  def test_average_price_per_merchant2
    skip
    se = SalesEngine.from_csv({:items =>
                  "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal 35,
    sa.average_price_per_merchant2.to_f.round(0)
  end


end
