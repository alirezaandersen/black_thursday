require 'test_helper'
require 'customer'

class CustomerTest < Minitest::Test

  attr_reader :c_time, :u_time

  def setup
    @c_time = Time.new(2016, 01, 04, 11, 27, 39, "-07:00")
    @u_time = Time.new(2016, 01, 25, 05, 12, 50, "-07:00")
  end

  def test_can_create_customer_info
    custom = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => c_time,
    :updated_at => u_time })
    assert_kind_of Customer, custom
  end

  def test_customer_id_returns_an_interger
    custom = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal 6, custom.id
  end

  def test_customer_will_return_customer_first_name
    custom = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal "Joan", custom.first_name
  end

  def test_customer_will_return_customer_last_name
    custom = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => c_time,
    :updated_at => u_time })
    assert_equal "Clarke", custom.last_name
  end

  def test_customer_will_return_customer_created_at
    custom = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => c_time,
    :updated_at => u_time })
    assert custom.created_at.kind_of?(Time)
  end

  def test_customer_will_return_customer_created_at
    custom = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => c_time,
    :updated_at => u_time })
    assert custom.updated_at.kind_of?(Time)
  end


end
