require 'test_helper'
require 'invoice_item_repository'
require 'invoice_items'


class InvoiceItemRepositoryTest < Minitest::Test

  def test_Invoice_Item_Repository_returns_all_known_invoice_items_instances
    inv_itm = InvoiceItemRepository.new
    assert_equal 0, inv_itm.all.length
  end

  def test_will_load_from_a_file
    inv_itm = InvoiceItemRepository.new
    inv_itm.load_data("./data/invoice_items.csv")
    assert_equal 21830, inv_itm.all.length
  end

  def test_Invoice_can_find_by_id
    inv_itm1 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 101,
    :invoice_id => 201,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm2 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 102,
    :invoice_id => 202,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm = InvoiceItemRepository.new
    inv_itm.load_invoice_items([inv_itm1, inv_itm2])

    assert_equal 601, inv_itm.find_by_id(601).id
  end

  def test_Invoice_can_find_all_by_item_id
    inv_itm1 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 101,
    :invoice_id => 201,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm2 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 102,
    :invoice_id => 202,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm3 = InvoiceItems.new({
    :id          => 602,
    :item_id  => 102,
    :invoice_id => 203,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm = InvoiceItemRepository.new
    inv_itm.load_invoice_items([inv_itm1, inv_itm2, inv_itm3])

    assert_equal [inv_itm2, inv_itm3], inv_itm.find_all_by_item_id(102)
  end

  def test_Invoice_can_find_all_by_invoice_id
    inv_itm1 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 101,
    :invoice_id => 203,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm2 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 102,
    :invoice_id => 202,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm3 = InvoiceItems.new({
    :id          => 602,
    :item_id  => 102,
    :invoice_id => 203,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm = InvoiceItemRepository.new
    inv_itm.load_invoice_items([inv_itm1, inv_itm2, inv_itm3])

    assert_equal [inv_itm1, inv_itm3], inv_itm.find_all_by_invoice_id(203)
  end

  def test_Invoice_returns_empty_array_if_given_invalid_item_id
    inv_itm1 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 101,
    :invoice_id => 201,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm2 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 102,
    :invoice_id => 202,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm = InvoiceItemRepository.new
    inv_itm.load_invoice_items([inv_itm1, inv_itm2])

    assert inv_itm.find_all_by_item_id(123).empty?
  end

  def test_Invoice_returns_empty_array_if_given_invalid_invoice_id
    inv_itm1 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 101,
    :invoice_id => 201,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm2 = InvoiceItems.new({
    :id          => 601,
    :item_id  => 102,
    :invoice_id => 202,
    :quantity => 5,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv_itm = InvoiceItemRepository.new
    inv_itm.load_invoice_items([inv_itm1, inv_itm2])

    assert inv_itm.find_all_by_invoice_id(213).empty?
  end

end
