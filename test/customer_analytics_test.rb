require 'minitest'
require 'customer'
require 'invoice'
require 'sales_engine'
require 'sales_analyst'
require 'mocha/mini_test'

class CustomerAnalyticsTest < Minitest::Test
  def make_invoice(id, cust_id, inv_total, paid_stat, merch_id = 8)
    inv = Invoice.new({
    :id          => id,
    :customer_id => cust_id,
    :merchant_id => merch_id,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv.stubs(:total).returns(inv_total)
    inv.stubs(:is_paid_in_full?).returns(paid_stat)
    inv
  end

  def test_get_the_top_buyers
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })
    c2 = Customer.new({
    :id => 21,
    :first_name => "Ali",
    :last_name => "Andersen",
    :created_at => Time.new,
    :updated_at => Time.now
    })
    c3 = Customer.new({
    :id => 35,
    :first_name => "Amie",
    :last_name => "Foucheaux",
    :created_at => Time.new,
    :updated_at => Time.now
    })
    cust_list = [c1,c2,c3]
    invoice_details = [[[9.95,true]],[[10.50,true],[11.50,true],[13.00,true]],[[9.50,true], [45.65,false]]]
    inv_list = []
    cust_list.each_with_index do |cust, ind|
      invoice_details[ind].each_with_index do |detail, i2|
        inv_list << make_invoice(ind*i2, cust.id, detail[0], detail[1])
      end
    end

    args={items: [], customers: cust_list, invoices: inv_list}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c2, c1], sa.top_buyers(2)
  end

  def test_top_merchant_for_customer_if_each_invoice_has_a_unique_merchant
    m1 = Merchant.new({:name => "Ali's glitter taphouse",
      :id => 356})
    m2 = Merchant.new({:name => "Erinna's dog spoiling services", :id => 743})

    c1 = Customer.new({
    :id => 21,
    :first_name => "Ali",
    :last_name => "Andersen",
    :created_at => Time.new,
    :updated_at => Time.now
    })

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 21,
    :merchant_id => 743,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })

    inv_item1 = InvoiceItem.new({
    :id          => 998,
    :item_id     => 25,
    :invoice_id  => 1,
    :quantity    => 3,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at => Time.new,
    :updated_at => Time.now })
    inv_item2 = InvoiceItem.new({
    :id          => 991,
    :item_id     => 37,
    :invoice_id  => 1,
    :quantity    => 4,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item3 = InvoiceItem.new({
    :id          => 876,
    :item_id     => 135,
    :invoice_id  => 2,
    :quantity    => 6,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    args={customers: [c1], invoices: [inv1, inv2], invoice_items: [inv_item1, inv_item2, inv_item3], merchants: [m1,m2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)

    assert_equal m1, sa.top_merchant_for_customer(21)
  end

  def test_top_merchant_for_customer_if_there_are_repeat_merchants_on_different_invoices
    m1 = Merchant.new({:name => "Ali's glitter taphouse",
      :id => 356})
    m2 = Merchant.new({:name => "Erinna's dog spoiling services", :id => 743})

    c1 = Customer.new({
    :id => 21,
    :first_name => "Ali",
    :last_name => "Andersen",
    :created_at => Time.new,
    :updated_at => Time.now
    })

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 21,
    :merchant_id => 743,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })

    inv3 = Invoice.new({
    :id          => 3,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })

    inv_item1 = InvoiceItem.new({
    :id          => 998,
    :item_id     => 25,
    :invoice_id  => 1,
    :quantity    => 3,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item2 = InvoiceItem.new({
    :id          => 991,
    :item_id     => 37,
    :invoice_id  => 3,
    :quantity    => 4,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item3 = InvoiceItem.new({
    :id          => 876,
    :item_id     => 135,
    :invoice_id  => 2,
    :quantity    => 6,
    :unit_price  => BigDecimal.new(1099,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    args={customers: [c1], invoices: [inv1, inv2, inv3], invoice_items: [inv_item1, inv_item2, inv_item3], merchants: [m1,m2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)

    assert_equal m1, sa.top_merchant_for_customer(21)
  end

end
