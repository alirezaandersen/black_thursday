require 'test_helper'
require 'sales_engine'

class SalesEngineTest < Minitest::Test
  def test_defaults_with_an_item_repository_and_a_merchant_repository
    se= SalesEngine.new
    assert_kind_of ItemRepository, se.items
    assert_kind_of MerchantRepository, se.merchants
  end

  def test_can_load_from_data
    i1 = Item.new({:name => "Best item",
      :description => "No explanation needed",
      :unit_price => BigDecimal.new(99.73, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 23457,
      :id => 13})
    m1 = Merchant.new({:name => "Ali's glitter taphouse",
      :id => 356})
    se = SalesEngine.from_data({:items => [i1],
      :merchants => [m1]})
    assert_equal [m1], se.merchants.all
    assert_equal [i1], se.items.all
  end

  def test_loads_all_items
    se = SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    assert_equal 1367, se.items.all.length
  end

  def test_loads_all_merchants
    se= SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    assert_equal 475, se.merchants.all.length
  end

  def test_can_find_a_specific_merchant
    se= SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    merchant_name = "HeadyMamaCreations"
    assert_equal "HeadyMamaCreations", se.merchants.find_by_name(merchant_name).name
  end

  def test_can_find_an_item_by_merchant_id
    se= SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv"})
    merchant_id = 12334235
    item = se.items.find_all_by_merchant_id(merchant_id)[0]
    assert_equal 8000, item.unit_price
    assert_equal 263397201, item.id
  end

  def test_can_load_all_invoices
    se= SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv",
                  :invoices =>"./data/invoices.csv"})
    assert_equal 4985, se.invoices.all.length
  end

  def test_invoices_knows_their_merchants
    se= SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv",
                  :invoices =>"./data/invoices.csv"})
    assert_equal "babypantry",se.invoices.all[43].merchant.name
    assert_equal "enchantmentproduct",se.invoices.all[117].merchant.name
  end

  def test_merchants_know_their_invoices
    se= SalesEngine.from_csv({:items => "./data/items.csv",
                  :merchants => "./data/merchants.csv",
                  :invoices =>"./data/invoices.csv"})
    merchant = se.merchants.find_by_id(12336165)
    assert_equal 6, merchant.invoices.length
    assert merchant.invoices.all? {|invoice| invoice.merchant.name == "PackingMonkey"}
  end
  
end
