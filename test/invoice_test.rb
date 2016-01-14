require 'test_helper'
require 'invoice'
class InoviceTest < Minitest::Test

  def setup
    @some_time = Time.new(2007,11,1,15,25,0, "+09:00")
  end

  def test_can_create_a_new_invoice
    inv = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8,
    :status      => "pending",
    :created_at  => @some_time,
    :updated_at  => @some_time,
    })
    assert_kind_of Invoice, inv
  end

  def test_ID_will_return_an_interger
    inv = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8,
    :status      => "pending",
    :created_at  => @some_time,
    :updated_at  => @some_time,
    })
    assert_equal 6,  inv.id
  end

  def test_invoice_returns_the_customer_id
    inv = Invoice.new({
    :id          => 6,
    :customer_id => 18,
    :merchant_id => 8,
    :status      => "pending",
    :created_at  => @some_time,
    :updated_at  => @some_time,
    })
    assert_equal 18,  inv.customer_id
  end

  def test_invoice_returns_the_merchant_id
    inv = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => @some_time,
    :updated_at  => @some_time,
    })
    assert_equal 8888123,  inv.merchant_id
  end

  def test_invoice_will_return_a_created_at_time

    inv = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => @some_time,
    :updated_at  => @some_time,
    })
    assert_equal @some_time, inv.created_at
    assert_kind_of Time, inv.created_at
  end

  def test_invoice_will_return_a_updated_at_time
    inv = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8888123,
    :status      => "pending",
    :created_at  => @some_time,
    :updated_at  => @some_time,
    })
    assert_equal @some_time, inv.updated_at
    assert_kind_of Time, inv.created_at
  end
end
