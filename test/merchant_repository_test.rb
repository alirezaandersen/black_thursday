require 'test_helper'
require 'merchant_repository'

class SmallMerchantRepositoryTest < Minitest::Test
  def test_by_default_has_no_items
    mr = MerchantRepository.new
    assert_equal 0, mr.all.length
  end

  def test_can_load_a_single_item
    mr = MerchantRepository.new
    mr.load_merchants([Merchant.new({:name => "Ali's glitter taphouse",
      :id => 356})])
    assert_equal 1, mr.all.length
    assert_equal "Ali's glitter taphouse", mr.all[0].name
  end

  def test_all_returns_multiple_items
    mr = MerchantRepository.new
    mr.load_merchants([Merchant.new({:name => "Ali's glitter taphouse",
      :id => 356}), Merchant.new({:name => "Erinna's dog spoiling services", :id => 763}), Merchant.new({:name => "Horacio's Pizzicatos", :id => 80})])
    assert_equal 3, mr.all.length
    assert_equal "Erinna's dog spoiling services", mr.all[1].name
    assert_equal 80, mr.all[2].id
  end

end


class FromFileMerchantRepositoryTest < Minitest::Test

  def test_loads_data
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    assert_equal 12334105, mr.all[0].id
    assert_equal "Shopin1901", mr.all[0].name
    assert_equal 476, mr.all.length
  end

  def test_find_by_matching_id
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchant = mr.find_by_id(12334442)
    assert_equal 12334442, merchant.id
    assert_equal "isincerely88", merchant.name

  end

  def test_will_return_nil_if_invalid_Merchant_id
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchant = mr.find_by_id(105)
    assert_nil merchant
  end

  def test_find_by_name
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchant = mr.find_by_name("JustReallyCoolStuff")
    assert_equal "JustReallyCoolStuff", merchant.name
    assert_equal 12334662, merchant.id
  end

  def test_will_return_nil_if_invalid_Merchant_name
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchant = mr.find_by_name("Amie")
    assert_nil merchant
  end

  def test_will_find_by_name_regardless_of_case
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchant = mr.find_by_name("DisCoUntDiVA56")
    assert_equal "DiscountDiva56", merchant.name
    assert_equal 12334510, merchant.id
  end

  def test_will_find_all_Merchants_by_name

    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchants = mr.find_all_by_name("the")
    assert_equal "TheLilPinkBowtique", merchants[0].name
    assert_equal 24, merchants.length
  end

  def test_will_find_all_Merchants_by_name_is_case_insensitive

    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    merchants = mr.find_all_by_name("ArT")
    assert_equal "fancybookart", merchants.last.name
    assert_equal 35, merchants.length
  end
end
