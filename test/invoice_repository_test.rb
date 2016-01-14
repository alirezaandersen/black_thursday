require 'test_helper'
require 'invoice_repository'
require 'invoice'

class InvoiceRepositoryTest < Minitest::Test
  def test_by_default_has_no_invoices
    invr = InvoiceRepository.new
    assert_equal 0, invr.all.length
  end

  def test_can_load_a_single_invoice
    inv = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    invr = InvoiceRepository.new
    invr.load_invoices([inv])
    assert_equal 1, invr.all.length
    assert_equal 6, invr.all[0].id
  end

  def test_all_returns_multiple_invoices
    inv1 = Invoice.new({
    :id          => 61,
    :customer_id => 25,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2 = Invoice.new({
    :id          => 62,
    :customer_id => 7,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3 = Invoice.new({
    :id          => 63,
    :customer_id => 17,
    :merchant_id => 8894123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2, inv3])
    assert_equal 3, invr.all.length
    assert_equal [inv1, inv2, inv3], invr.all
    assert_equal 61, invr.all[0].id
    assert_equal 7, invr.all[1].customer_id
    assert_equal 8894123, invr.all[2].merchant_id
  end

  def test_Invoice_can_find_by_ID
    inv1 = Invoice.new({
    :id          => 632,
    :customer_id => 25,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2 = Invoice.new({
    :id          => 623,
    :customer_id => 25,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])

    assert_equal 623, invr.find_by_id(623).id
  end

  def test_returns_nil_when_invalid_id
      inv1 = Invoice.new({
    :id          => 632,
    :customer_id => 25,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2 = Invoice.new({
    :id          => 771234,
    :customer_id => 25,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])

    assert_equal 623, invr.find_by_id(623).id
  end
  # def create_items(n)
  #   (0...n).map do |count|
  #     Item.new({:name => "Item \##{count}",
  #       :description => "This is generic item number #{count}",
  #       :unit_price => BigDecimal.new(count*3.97, 4),
  #       :created_at => Time.new,
  #       :updated_at => Time.now,
  #       :merchant_id => 2300+count,
  #       :id => 13+count})
  #   end
  # end

  #
  # def test_can_find_by_id
  #   ir = ItemRepository.new
  #   ir.load_items(create_items(5))
  #   item = ir.find_by_id(16)
  #   assert_equal "Item \#3", item.name
  #   assert_equal 2303, item.merchant_id
  #   item = ir.find_by_id(13)
  #   assert_equal "Item \#0", item.name
  #   assert_equal "This is generic item number 0", item.description
  # end

end
