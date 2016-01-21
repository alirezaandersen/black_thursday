require_relative 'customer'

class CustomerRepository

  attr_reader :customers

  def initialize
    @customers = []
  end


  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      customers << Customer.new( {:id => row[:id].to_i,
      :first_name => row[:first_name],
      :last_name => row[:last_name],
      :created_at => Time.parse(row[:created_at]),
      :updated_at => Time.parse(row[:updated_at])
      } )
    end
  end

  def load_repo_items(custs_in)
    custs_in.each { |customer| customers << customer }
  end

  def all
    customers
  end

  def find_by_id(id_number)
    customers.find { |customer| customer.id == id_number }
  end

  def find_all_by_first_name(first_name)
    customers.find_all { |customer|
      customer.first_name.downcase.include?(first_name.downcase) }
  end

  def find_all_by_last_name(last_name)
    customers.find_all { |customer|
      customer.last_name.downcase.include?(last_name.downcase) }
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
