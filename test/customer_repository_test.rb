require 'test_helper'
require 'customer_repository'

class CustomerRepositoryTest < Minitest::Test

  attr_reader :c_time, :u_time

  def setup
    @c_time = Time.new(2016, 01, 04, 11, 27, 39, "-07:00")
    @u_time = Time.new(2016, 01, 25, 05, 12, 50, "-07:00")
  end


  def test_customer_repo_returns_all_customers

    custom1 = Customer.new({
    :id => 2,
    :first_name => "Erinna",
    :last_name => "Chen",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom2 = Customer.new({
    :id => 6,
    :first_name => "Ali",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom3 = Customer.new({
    :id => 3,
    :first_name => "Ali",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    customer = CustomerRepository.new
    customer.load_customers([custom1, custom2, custom3])

    assert_equal [custom1, custom2, custom3], customer.all
  end

  def test_customers_first_name_will_be_returned

    custom1 = Customer.new({
    :id => 2,
    :first_name => "Ali",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom2 = Customer.new({
    :id => 4,
    :first_name => "Ali",
    :last_name => "Glitter",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom3 = Customer.new({
    :id => 6,
    :first_name => "Ali",
    :last_name => "Baller",
    :created_at => c_time,
    :updated_at => u_time
    })
    customer = CustomerRepository.new
    customer.load_customers([custom1, custom2, custom3])

    assert_equal ([custom1, custom2, custom3]), customer.find_all_by_first_name("Ali")
    assert_empty customer.find_all_by_first_name("Troll")
  end

  def test_customers_last_name_will_be_returned
    custom1 = Customer.new({
    :id => 2,
    :first_name => "Glitter",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom2 = Customer.new({
    :id => 6,
    :first_name => "Boobo",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom3 = Customer.new({
    :id => 6,
    :first_name => "Ziba",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    customer = CustomerRepository.new
    customer.load_customers([custom1, custom2, custom3])

    assert_equal [custom1, custom2,custom3], customer.find_all_by_last_name("Andersen")
    assert_empty customer.find_all_by_last_name("Foucheaux")
  end

  def test_customer_id_will_return_customer_info
    custom1 = Customer.new({
    :id => 2,
    :first_name => "Boobo",
    :last_name => "Andersen",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom2 = Customer.new({
    :id => 3,
    :first_name => "Edwin",
    :last_name => "Jue",
    :created_at => c_time,
    :updated_at => u_time
    })
    custom3 = Customer.new({
    :id => 6,
    :first_name => "Jigga",
    :last_name => "Sun",
    :created_at => c_time,
    :updated_at => u_time
    })
    customer = CustomerRepository.new
    customer.load_customers([custom1, custom2, custom3])

    assert_equal custom3, customer.find_by_id(6)
    assert_nil customer.find_by_id(21)
  end

  def test_will_load_customers_data_from_a_file

    customer = CustomerRepository.new
    customer.load_data("./data/customers.csv")
    assert_equal 1000, customer.all.length
    assert_equal "Madie", customer.find_by_id(992).first_name
  end
end
