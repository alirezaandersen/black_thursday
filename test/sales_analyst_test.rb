require 'test_helper'
require 'sales_analyst'


class SalesAnalystTest < Minitest::Test

  def test_Analyst_has_a_SaleEngine
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
