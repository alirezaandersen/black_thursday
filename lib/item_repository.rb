require_relative 'item'
require 'time'
require 'bigdecimal'

class ItemRepository

  attr_reader :items

  def initialize
    @items = []
  end

  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      items << Item.new({:name => row[:name].to_s,
        :description => row[:description].to_s,
        :unit_price => BigDecimal.new(row[:unit_price]),
        :created_at => Time.parse(row[:created_at]),
        :updated_at => Time.parse(row[:updated_at]),
        :merchant_id => row[:merchant_id].to_i,
        :id => row[:id].to_i})
      end
  end

  def load_repo_items(items_in)
    items_in.each { |item|  items << item }
  end

  def find_by_id(id_number)
    items.find { |item| item.id == id_number }
  end

  def find_by_name(name)
    items.find { |item| item.name.downcase == name.downcase }
  end

  def find_all_with_description(description)
    items.find_all { |item| item.description.downcase == description.downcase }
  end

  def find_all_by_price(price)
    items.find_all { |item|  item.unit_price == price }
  end

  def find_all_by_price_in_range(range)
    items.find_all { |item| item.unit_price >= range.min && item.unit_price <= range.max }
  end

  def find_all_by_merchant_id(merchant_id)
    items.find_all { |item| item.merchant_id == merchant_id }
  end

  def all
    items
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end


end
