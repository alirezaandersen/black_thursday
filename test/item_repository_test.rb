require 'test_helper'
require 'item_repository'
require 'csv'

class SmallItemRepositoryTest < Minitest::Test
  def test_by_default_has_no_items
    ir = ItemRepository.new
    assert_equal 0, ir.all.length
  end

  def test_can_load_a_single_item
    ir = ItemRepository.new
    ir.load_items([Item.new({:name => "Best item",
      :description => "No explanation needed",
      :unit_price => BigDecimal.new(99.73, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 23457,
      :id => 13})])
    assert_equal 1, ir.all.length
    assert_equal "Best item", ir.all[0].name
    assert_equal 99.73, ir.all[0].unit_price
    assert_equal 23457, ir.all[0].merchant_id
    assert_equal 13, ir.all[0].id
  end

  def test_all_returns_multiple_items
    ir = ItemRepository.new
    i1 = Item.new({:name => "Best item",
      :description => "No explanation needed",
      :unit_price => BigDecimal.new(99.73, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 23457,
      :id => 13})
    i2 = Item.new({:name => "Weak item",
      :description => "Not as cool as the rest",
      :unit_price => BigDecimal.new(0.99, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 98110,
      :id => 356})
    ir.load_items([i1, i2])
    assert_equal [i1, i2], ir.all
  end

  def create_items(n)
    (0...n).map do |count|
      Item.new({:name => "Item \##{count}",
        :description => "This is generic item number #{count}",
        :unit_price => BigDecimal.new(count*3.97, 4),
        :created_at => Time.new,
        :updated_at => Time.now,
        :merchant_id => 2300+count,
        :id => 13+count})
    end
  end

  def test_can_load_multiple_items
    ir = ItemRepository.new
    ir.load_items(create_items(5))
    assert_equal 5, ir.all.length
    assert ir.all.all? {|item| item.kind_of?(Item)}
    assert_equal 15, ir.all[2].id
    assert_equal BigDecimal.new(4*3.97, 4), ir.all.last.unit_price
  end

  def test_can_find_by_id
    ir = ItemRepository.new
    ir.load_items(create_items(5))
    item = ir.find_by_id(16)
    assert_equal "Item \#3", item.name
    assert_equal 2303, item.merchant_id
    item = ir.find_by_id(13)
    assert_equal "Item \#0", item.name
    assert_equal "This is generic item number 0", item.description
  end


end


class LargeItemRepositoryTest <  Minitest::Test
  def test_it_can_load_data
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    assert_equal 1367, ir.all.length
  end

  def test_can_find_by_ID
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    item = ir.find_by_id(263395237)
    assert_equal 263395237, item.id
    assert_equal "510+ RealPush Icon Set", item.name
  end

  def test_returns_nil_if_id_not_in_items
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    item = ir.find_by_id(102)
    assert_nil item
  end

  def test_can_find_item_by_name
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    item = ir.find_by_name("Disney scrabble frames")
    assert_equal "Disney scrabble frames", item.name
    assert_equal 263395721, item.id
  end

  def test_can_find_item_by_name_regardless_of_case
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    item = ir.find_by_name("Free standing Woden letters")
    assert_equal "Free standing Woden letters", item.name
    assert_equal 263396013, item.id
  end

  def test_can_find_all_by_description
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    description = "Acrylique sur toile exécutée en 2011\nFormat : 46 x 55 cm\nToile sur châssis en bois - non encadré\nArtiste : Flavien Couche - Artiste côté Akoun\n\nTABLEAU VENDU AVEC FACTURE ET CERTIFICAT D&#39;AUTHETICITE\n\nwww.flavien-couche.com"
    item = ir.find_all_with_description(description)
    assert_equal description, item[0].description
    assert_equal 263396255, item[0].id
  end

  def test_find_all_by_price
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    items = ir.find_all_by_price(4800)
    assert_equal 4800, items[0].unit_price
    assert_equal 7, items.length
  end

  def test_find_all_by_price_in_range
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    range = Range.new(13,150)
    items = ir.find_all_by_price_in_range(range)
    assert_equal 7, items.length
  end

  def test_find_all_by_merchant_ids
    ir = ItemRepository.new
    ir.load_data("./data/items.csv")
    items = ir.find_all_by_merchant_id(12334442)
    assert_equal 12334442, items[0].merchant_id
    assert_equal 5, items.length
  end

end
