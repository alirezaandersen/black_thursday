require 'test_helper'
require 'transaction'
require 'csv'


class TransactionTest < Minitest::Test

  attr_reader :c_time, :u_time

  def setup
    @c_time = Time.new(2016, 01, 04, 11, 27, 39, "-07:00")
    @u_time = Time.new(2016, 01, 25, 05, 12, 50, "-07:00")
  end

  def test_can_create_a_new_invoice
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
    assert_kind_of Transaction, trans
  end

  def test_will_return_the_invoice_ID
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal 8, trans.invoice_id
  end

  def test_will_return_the_Transaction_credit_card_number
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal "4242424242424242", trans.credit_card_number
  end

  def test_will_return_the_Transaction_credit_card_expiration_date
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal "0220", trans.credit_card_expiration_date
  end

  def test_will_return_the_Transaction_results
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal "success", trans.result
  end

  def test_will_return_the_Transaction_created_at_time
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
  assert trans.created_at.kind_of?(Time)
  end

  def test_will_return_the_Transaction_updated_at_time
    trans = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => c_time,
    :updated_at => u_time })
    assert trans.updated_at.kind_of?(Time)
  end

end
