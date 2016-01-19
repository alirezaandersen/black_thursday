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
    :status      => :pending,
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
    :status      => :pending,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2 = Invoice.new({
    :id          => 62,
    :customer_id => 7,
    :merchant_id => 8888123,
    :status      => :pending,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv3 = Invoice.new({
    :id          => 63,
    :customer_id => 17,
    :merchant_id => 8894123,
    :status      => :pending,
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

  def test_Invoice_can_find_by_id
    inv1 = Invoice.new({
    :id          => 632,
    :customer_id => 25,
    :merchant_id => 8888123,
    :status      => :pending,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    inv2 = Invoice.new({
    :id          => 623,
    :customer_id => 23,
    :merchant_id => 8912212,
    :status      => :pending,
    :created_at  => Time.new,
    :updated_at  => Time.now,
    })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])

    assert_equal 623, invr.find_by_id(623).id
    assert_equal 23, invr.find_by_id(623).customer_id
    assert_equal 632, invr.find_by_id(632).id
    assert_equal 8888123, invr.find_by_id(632).merchant_id
  end

  def test_returns_nil_when_invoice_not_in_repo
    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert_nil invr.find_by_id(623)
  end

  def test_find_all_invoices_by_customer_ID
    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert_equal [inv1, inv2], invr.find_all_by_customer_id(25)
  end

  def test_will_return_empty_array_if_given_invalid_customer_id
    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 252,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert invr.find_all_by_customer_id(255).empty?
  end

  def test_can_find_invoice_by_specific_customer_id
    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 252,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert_equal [inv2],invr.find_all_by_customer_id(252)
  end

  def test_find_all_invoices_by_merchant_ID
    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert_equal [inv1, inv2], invr.find_all_by_merchant_id(8888123)
  end

  def test_will_return_empty_array_if_given_invlaid_merchant_id

    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 252,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert invr.find_all_by_merchant_id(255).empty?
  end

  def test_can_find_invoice_by_specific_merchant_id
    inv1 = Invoice.new({
      :id          => 632,
      :customer_id => 25,
      :merchant_id => 8858123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    inv2 = Invoice.new({
      :id          => 771234,
      :customer_id => 252,
      :merchant_id => 8888123,
      :status      => :pending,
      :created_at  => Time.new,
      :updated_at  => Time.now,
      })
    invr = InvoiceRepository.new
    invr.load_invoices([inv1, inv2])
    assert_equal 2, invr.all.length
    assert_equal [inv2],invr.find_all_by_merchant_id(8888123)
  end


    def test_find_all_invoices_by_status
      inv1 = Invoice.new({
        :id          => 632,
        :customer_id => 256,
        :merchant_id => 8854123,
        :status      => :pending,
        :created_at  => Time.new,
        :updated_at  => Time.now,
        })
      inv2 = Invoice.new({
        :id          => 771234,
        :customer_id => 25,
        :merchant_id => 8888123,
        :status      => :pending,
        :created_at  => Time.new,
        :updated_at  => Time.now,
        })
      invr = InvoiceRepository.new
      invr.load_invoices([inv1, inv2])
      assert_equal 2, invr.all.length
      assert_equal [inv1, inv2], invr.find_all_by_status(:pending)
    end

    def test_will_return_empty_array_if_given_invalid_status

      inv1 = Invoice.new({
        :id          => 632,
        :customer_id => 25,
        :merchant_id => 8888123,
        :status      => :pending,
        :created_at  => Time.new,
        :updated_at  => Time.now,
        })
      inv2 = Invoice.new({
        :id          => 771234,
        :customer_id => 252,
        :merchant_id => 8888123,
        :status      => :pending,
        :created_at  => Time.new,
        :updated_at  => Time.now,
        })
      invr = InvoiceRepository.new
      invr.load_invoices([inv1, inv2])
      assert_equal 2, invr.all.length
      assert invr.find_all_by_status(:failing).empty?
    end

    def test_can_find_invoice_by_specific_status
      inv1 = Invoice.new({
        :id          => 632,
        :customer_id => 25,
        :merchant_id => 8858123,
        :status      => :pending,
        :created_at  => Time.new,
        :updated_at  => Time.now,
        })
      inv2 = Invoice.new({
        :id          => 771234,
        :customer_id => 252,
        :merchant_id => 8888123,
        :status      => :active,
        :created_at  => Time.new,
        :updated_at  => Time.now,
        })
      invr = InvoiceRepository.new
      invr.load_invoices([inv1, inv2])
      assert_equal 2, invr.all.length
      assert_equal [inv2],invr.find_all_by_status(:active)
    end

    def test_will_load_from_a_file
      invr = InvoiceRepository.new
      invr.load_data("./data/invoices.csv")
      assert_equal 4985, invr.all.length
    end

    def test_check_all_methods_work_on_the_bigger_data_set
      invr = InvoiceRepository.new
      invr.load_data("./data/invoices.csv")
      assert_equal 4985, invr.all.length
      assert_equal 12335128, invr.find_by_id(262).merchant_id
      assert_equal 8, invr.find_all_by_customer_id(100).length
      assert_equal 13, invr.find_all_by_merchant_id(12334807).length
      assert_equal 673, invr.find_all_by_status(:returned).length
      assert_equal 25, invr.find_all_by_status(:returned).first.id
      assert invr.find_all_by_merchant_id(255).empty?
    end



end
