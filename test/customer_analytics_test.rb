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

  def test_best_invoice_by_revenue_and_quantity_single_invoice_item
    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)
    inv_item1 = InvoiceItem.new({
    :id          => 998,
    :item_id     => 25,
    :invoice_id  => 1,
    :quantity    => 3,
    :unit_price  => BigDecimal.new(1000,4),
    :created_at => Time.new,
    :updated_at => Time.now })
    args={invoices: [inv1], invoice_items: [inv_item1]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal inv1, sa.best_invoice_by_revenue
    assert_equal BigDecimal.new(30.00,4),  sa.best_invoice_by_revenue.total
    assert_equal inv1, sa.best_invoice_by_quantity
    assert_equal 3, sa.best_invoice_by_quantity.quantity
  end

  def test_best_invoice_by_revenue_and_quantity_single_invoice_item_only_if_invoice_has_been_paid
    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(false)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 31,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(true)

    inv_item1 = InvoiceItem.new({
    :id          => 998,
    :item_id     => 25,
    :invoice_id  => 1,
    :quantity    => 3,
    :unit_price  => BigDecimal.new(1000,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item2 = InvoiceItem.new({
    :id          => 998,
    :item_id     => 25,
    :invoice_id  => 2,
    :quantity    => 5,
    :unit_price  => BigDecimal.new(1565,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    args={invoices: [inv1, inv2], invoice_items: [inv_item1, inv_item2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal inv2, sa.best_invoice_by_revenue
    assert_equal BigDecimal.new(78.25,4),  sa.best_invoice_by_revenue.total
    assert_equal inv2, sa.best_invoice_by_quantity
    assert_equal 5, sa.best_invoice_by_quantity.quantity
  end

  def test_can_find_customers_with_unpaid_invoices_one_customer_with_one_customer_without
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(false)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(true)

    args={customers: [c1,c2], invoices: [inv1, inv2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c2], sa.customers_with_unpaid_invoices
  end

  def test_can_find_customers_with_unpaid_invoices_two_customers
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(false)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(false)

    args={customers: [c1,c2], invoices: [inv1, inv2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c1,c2], sa.customers_with_unpaid_invoices
  end

  def test_can_find_customers_with_unpaid_invoices_customer_with_two_unpaid_invoices
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(false)

    inv3 = Invoice.new({
    :id          => 3,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3.stubs(:is_paid_in_full?).returns(false)


    args={customers: [c1,c2], invoices: [inv1, inv2, inv3]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c1], sa.customers_with_unpaid_invoices
  end

  def test_can_find_customers_with_unpaid_invoices_customer_with_an_unpaid_and_a_paid_invoice
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(true)

    inv3 = Invoice.new({
    :id          => 3,
    :customer_id => 987,
    :merchant_id => 65,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3.stubs(:is_paid_in_full?).returns(false)


    args={customers: [c1,c2], invoices: [inv1, inv2, inv3]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c1], sa.customers_with_unpaid_invoices
  end

  def test_can_find_one_time_buyers_single_customers
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })
    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 987,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)
    args={customers: [c1], invoices: [inv1]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c1], sa.one_time_buyers
  end

  def test_can_find_one_time_buyers_two_customers_one_with_multiple_invoices
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(true)

    inv3 = Invoice.new({
    :id          => 3,
    :customer_id => 987,
    :merchant_id => 65,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3.stubs(:is_paid_in_full?).returns(true)

    args={customers: [c1,c2], invoices: [inv1, inv2, inv3]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c2], sa.one_time_buyers
  end

  def test_can_find_no_one_time_buyers_single_customer_no_valid_invoices
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })
    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 987,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(false)
    args={customers: [c1], invoices: [inv1]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [], sa.one_time_buyers
  end

  def test_can_find_one_time_buyers_two_customers_no_valid_invoices
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(false)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(false)

    inv3 = Invoice.new({
    :id          => 3,
    :customer_id => 987,
    :merchant_id => 65,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3.stubs(:is_paid_in_full?).returns(false)

    args={customers: [c1,c2], invoices: [inv1, inv2, inv3]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [], sa.one_time_buyers
  end

  def test_can_find_one_time_buyers_if_has_only_one_paid_invoice
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

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 21,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 635,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(true)

    inv3 = Invoice.new({
    :id          => 3,
    :customer_id => 987,
    :merchant_id => 65,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3.stubs(:is_paid_in_full?).returns(false)

    inv4 = Invoice.new({
    :id          => 4,
    :customer_id => 987,
    :merchant_id => 333,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv4.stubs(:is_paid_in_full?).returns(false)

    args={customers: [c1,c2], invoices: [inv1, inv2, inv3, inv4]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [c2,c1], sa.one_time_buyers
  end

  def test_can_find_one_time_buyers_items
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 987,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv_item1 = InvoiceItem.new({
    :id          => 31,
    :item_id     => 7,
    :invoice_id  => 1,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(1900,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item2 = InvoiceItem.new({
    :id          => 32,
    :item_id     => 17,
    :invoice_id  => 1,
    :quantity    => 7,
    :unit_price  => BigDecimal.new(4300,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    i1 = Item.new({:name => "Glitter tail braids",
      :description => "For those flashy occasions",
      :unit_price => BigDecimal.new(1900, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 7})
    i2 = Item.new({:name => "Platinum Diamond (0.25C) pawdicure",
      :description => "Be dazzling your paws",
      :unit_price => BigDecimal.new(4300, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 17})

    args={customers: [c1], invoices: [inv1], items: [i1, i2], invoice_items: [inv_item1, inv_item2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [i2], sa.one_time_buyers_item
  end

  def test_can_find_one_time_buyers_items_same_quantity
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 987,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv_item1 = InvoiceItem.new({
    :id          => 31,
    :item_id     => 7,
    :invoice_id  => 1,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(1900,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item2 = InvoiceItem.new({
    :id          => 32,
    :item_id     => 17,
    :invoice_id  => 1,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(4300,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    i1 = Item.new({:name => "Glitter tail braids",
      :description => "For those flashy occasions",
      :unit_price => BigDecimal.new(1900, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 7})
    i2 = Item.new({:name => "Platinum Diamond (0.25C) pawdicure",
      :description => "Be dazzling your paws",
      :unit_price => BigDecimal.new(4300, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 17})

    args={customers: [c1], invoices: [inv1], items: [i1, i2], invoice_items: [inv_item1, inv_item2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [i1,i2], sa.one_time_buyers_item
  end

  def test_can_find_most_recently_bought_items
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 987,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv_item1 = InvoiceItem.new({
    :id          => 31,
    :item_id     => 7,
    :invoice_id  => 1,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(1900,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item2 = InvoiceItem.new({
    :id          => 32,
    :item_id     => 17,
    :invoice_id  => 1,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(4300,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    i1 = Item.new({:name => "Glitter tail braids",
      :description => "For those flashy occasions",
      :unit_price => BigDecimal.new(1900, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 7})
    i2 = Item.new({:name => "Platinum Diamond (0.25C) pawdicure",
      :description => "Be dazzling your paws",
      :unit_price => BigDecimal.new(4300, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 17})

    args={customers: [c1], invoices: [inv1], items: [i1, i2], invoice_items: [inv_item1, inv_item2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [i1,i2], sa.most_recently_bought_items(c1.id)
  end

  def test_can_find_most_recently_bought_items_if_there_is_two_invoices
    c1 = Customer.new({
    :id => 987,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => Time.new,
    :updated_at => Time.now
    })

    inv1 = Invoice.new({
    :id          => 1,
    :customer_id => 987,
    :merchant_id => 356,
    :status      => "pending",
    :created_at  => Time.parse("2012-01-23"),
    :updated_at  => Time.now,
    })
    inv1.stubs(:is_paid_in_full?).returns(true)

    inv2 = Invoice.new({
    :id          => 2,
    :customer_id => 987,
    :merchant_id => 430,
    :status      => "pending",
    :created_at  => Time.parse("2015-03-18"),
    :updated_at  => Time.now,
    })
    inv2.stubs(:is_paid_in_full?).returns(true)

    inv_item1 = InvoiceItem.new({
    :id          => 31,
    :item_id     => 7,
    :invoice_id  => 1,
    :quantity    => 2,
    :unit_price  => BigDecimal.new(1900,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    inv_item2 = InvoiceItem.new({
    :id          => 32,
    :item_id     => 17,
    :invoice_id  => 2,
    :quantity    => 5,
    :unit_price  => BigDecimal.new(4300,4),
    :created_at => Time.new,
    :updated_at => Time.now })

    i1 = Item.new({:name => "Glitter tail braids",
      :description => "For those flashy occasions",
      :unit_price => BigDecimal.new(1900, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 356,
      :id => 7})
    i2 = Item.new({:name => "Platinum Diamond (0.25C) pawdicure",
      :description => "Be dazzling your paws",
      :unit_price => BigDecimal.new(4300, 4),
      :created_at => Time.new,
      :updated_at => Time.now,
      :merchant_id => 430,
      :id => 17})

    args={customers: [c1], invoices: [inv1, inv2], items: [i1, i2], invoice_items: [inv_item1, inv_item2]}
    se = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se)
    assert_equal [i2], sa.most_recently_bought_items(c1.id)
  end
end
