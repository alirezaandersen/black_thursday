require 'test_helper'
require 'item_repository'


class ItemRepositoryTest <  Minitest::Test


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
