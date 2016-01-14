require 'csv'
require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants
  def initialize
    @merchants = []
  end

  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      merchants << Merchant.new({:name => row[:name], :id => row[:id]})
    end
  end

  def load_merchants(merchants_in)
    merchants_in.each do |merchant|
      merchants << merchant
    end
  end

  def find_by_id(id)
    merchants.find do |merchant|
      merchant.id == id
    end
  end

  def find_by_name(name)
    merchants.find do |merchant|
      merchant.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name)
    merchants.find_all do |merchant|
      merchant.name.downcase.include?(name.downcase)
    end
  end

  def all
    merchants
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
