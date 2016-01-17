require 'test_helper'
require 'invoice_item_repository'
require 'invoice_items'


class InvoiceItemReposistoryTest < Minitest::Test

  def test_Invoice_Item_Repository_returns_all_known_invoice_items_instances
    inv_itm = InvoiceItemReposistory.new
    assert_equal 0, inv_itm.all.length
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
    assert_equal 102, inv_itm.find_all_by_item_id(102)

  end

end
