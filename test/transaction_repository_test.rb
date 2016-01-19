require 'test_helper'
require 'transaction_repository'
require 'csv'
require 'invoice'


class TransactionRepositoryTest < Minitest::Test

  attr_reader :c_time, :u_time

  def setup
    @c_time = Time.new(2016, 01, 04, 11, 27, 39, "-07:00")
    @u_time = Time.new(2016, 01, 25, 05, 12, 50, "-07:00")
  end


  def test_transaction_will_return_an_all_by_invoice_id

    trans1 = Transaction.new({
    :id => 2,
    :invoice_id => 3,
    :credit_card_number => "5151424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans2 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5353424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans3 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans = TransactionRepository.new
    trans.load_transactions([trans1, trans2, trans3])

    assert_equal [trans2, trans3], trans.find_all_by_invoice_id(8)
  end

  def test_transaction_will_return_a_transactions_with_a_vaild_result_status

    trans1 = Transaction.new({
    :id => 2,
    :invoice_id => 3,
    :credit_card_number => "5151424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans2 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans3 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "failed",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans = TransactionRepository.new
    trans.load_transactions([trans1, trans2, trans3])

    assert_equal [trans1,trans2], trans.find_all_by_result("success")
  end

  def test_transaction_will_return_a_transactions_with_a_vaild_CC_number

    trans1 = Transaction.new({
    :id => 2,
    :invoice_id => 3,
    :credit_card_number => "5151424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans2 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans3 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "failed",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans = TransactionRepository.new
    trans.load_transactions([trans1, trans2, trans3])

    assert_equal [trans2,trans3], trans.find_all_by_credit_card_number("5252424242424242")
  end

  def test_transaction_will_return_a_transactions_with_a_invaild_CC_number

    trans1 = Transaction.new({
    :id => 2,
    :invoice_id => 3,
    :credit_card_number => "5151424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans2 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans3 = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "5252424242424242",
    :credit_card_expiration_date => "0220",
    :result => "failed",
    :created_at => c_time,
    :updated_at => u_time
    })
    trans = TransactionRepository.new
    trans.load_transactions([trans1, trans2, trans3])

    assert_empty trans.find_all_by_credit_card_number("5254311244242424242")
  end

  def test_will_load_transactions_from_a_file
    trans = TransactionRepository.new
    trans.load_data("./data/transactions.csv")
    assert_equal 4985, trans.all.length
  end
end
