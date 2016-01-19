require 'test_helper'
require 'invoice_items'
require 'csv'

class InvoiceItemsTest < Minitest::Test

  attr_reader :c_time, :u_time

  def setup
    @c_time = Time.new(2016, 01, 04, 11, 27, 39, "-07:00")
    @u_time = Time.new(2016, 01, 25, 05, 12, 50, "-07:00")
  end

  def test_can_create_a_new_invoice
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_kind_of InvoiceItem, inv_item
  end

  def test_Invoice_Items_id_will_return_an_interger
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_equal 6, inv_item.id
  end

  def test_Invoice_Items_item_id_will_return_item_id
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_equal 7, inv_item.item_id
  end

  def test_Invoice_Items_invoice_id_will_return_invoice_id
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_equal 8, inv_item.invoice_id
  end

  def test_Invoice_Items_will_return_quantity_in_interger_form
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_equal 1, inv_item.quantity
  end

  def test_Invoice_Items_will_return_unit_price
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_equal 1099, inv_item.unit_price
    assert_kind_of BigDecimal, inv_item.unit_price
  end

  def test_Invoice_Items_will_return_created_time
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert inv_item.created_at.kind_of?(Time)
  end

  def test_Invoice_Items_will_return_updated_time
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 1,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert inv_item.updated_at.kind_of?(Time)
  end

  def test_Invoice_Items_will_return_unit_price_to_dollar_conversion
    inv_item = InvoiceItem.new({
    :id          => 6,
    :item_id     => 7,
    :invoice_id  => 8,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(2198,4),
    :created_at  => c_time,
    :updated_at  => u_time })
    assert_equal 21.98, inv_item.unit_price_to_dollars
  end







end
