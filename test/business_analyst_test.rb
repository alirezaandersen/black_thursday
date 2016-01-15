require 'test_helper'
require 'sales_analyst'
require 'sales_engine'
require 'mocha/mini_test'

class IterTwoSalesAnalyst < Minitest::Test
  def test_can_find_average_invoice_for_a_merchant
    m1 = Merchant.new({:name => "M1", :id => 210})
    m2 = Merchant.new({:name => "M2", :id => 220})
    m1.stubs(:invoices).returns([1]*13)
    m2.stubs(:invoices).returns([1]*19)
    args = {invoices: [], merchants: [m1,m2]}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 16.00, sa.average_invoices_per_merchant
  end

  def test_can_find_average_invoice_for_a_merchant_standard_devation
    m1 = Merchant.new({:name => "M1", :id => 210})
    m2 = Merchant.new({:name => "M2", :id => 220})
    m3 = Merchant.new({:name => "M3", :id => 230})
    m4 = Merchant.new({:name => "M4", :id => 240})
    m5 = Merchant.new({:name => "M5", :id => 250})
    m1.stubs(:invoices).returns([1]*13)
    m2.stubs(:invoices).returns([1]*19)
    m3.stubs(:invoices).returns([1]*7)
    m4.stubs(:invoices).returns([1]*8)
    m5.stubs(:invoices).returns([1]*10)
    args = {invoices: [], merchants: [m1,m2, m3, m4, m5]}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 4.83, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_can_find_the_spectacular_guys
    merchs = []
    36.times do |n|
      m = Merchant.new({:name => "M#{n}", :id => n})
      m.stubs(:invoices).returns([1]*20)
      merchs << m
    end
    m1_spec = Merchant.new({:name => "Spec1", :id => 1433})
    m2_spec = Merchant.new({:name => "Spec2", :id => 2433})
    m3_spec = Merchant.new({:name => "Spec3", :id => 3433})
    m1_spec.stubs(:invoices).returns([1]*33)
    m2_spec.stubs(:invoices).returns([1]*37)
    m3_spec.stubs(:invoices).returns([1]*46)

    merchs += [m1_spec, m2_spec, m3_spec]
    args = {invoices: [], merchants: merchs}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 21.44, sa.average_invoices_per_merchant
    assert_equal 5.27, sa.average_invoices_per_merchant_standard_deviation
    assert_equal [m1_spec, m2_spec, m3_spec], sa.top_merchants_by_invoice_count
  end

  def test_can_find_the_terrible_guys
    merchs = []
    36.times do |n|
      m = Merchant.new({:name => "M#{n}", :id => n})
      m.stubs(:invoices).returns([1]*20)
      merchs << m
    end
    m1_bad = Merchant.new({:name => "Bad1", :id => 1433})
    m2_bad = Merchant.new({:name => "Bad2", :id => 2433})
    m3_bad = Merchant.new({:name => "Bad3", :id => 3433})
    m1_bad.stubs(:invoices).returns([1]*3)
    m2_bad.stubs(:invoices).returns([1]*4)
    m3_bad.stubs(:invoices).returns([1]*13)

    merchs += [m1_bad, m2_bad, m3_bad]
    args = {invoices: [], merchants: merchs}
    se_temp = SalesEngine.from_data(args)
    sa = SalesAnalyst.new(se_temp)

    assert_equal 18.97, sa.average_invoices_per_merchant
    assert_equal 3.81, sa.average_invoices_per_merchant_standard_deviation
    assert_equal [m1_bad, m2_bad], sa.bottom_merchants_by_invoice_count
  end




end