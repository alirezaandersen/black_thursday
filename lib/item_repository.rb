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

  def load_items(items_in)
    items_in.each do |item|
      items << item
    end
  end

  def find_by_id(id_number)
    items.find do |item|
      item.id == id_number
    end
  end

  def find_by_name(name)
    items.find do |item|
      item.name.downcase == name.downcase
    end
  end

  def find_all_with_description(description)
    items.find_all do |item|
      item.description.downcase == description.downcase
    end
  end

  def find_all_by_price(price)
    items.find_all do |item|
      item.unit_price_to_dollars == price
    end
  end

  def find_all_by_price_in_range(range)
    items.find_all do |item|
      item.unit_price_to_dollars >= range.min && item.unit_price_to_dollars <= range.max
    end
  end

  def find_all_by_merchant_id(merchant_id)
    items.find_all do |item|
      item.merchant_id == merchant_id
    end
  end

  def all
    items
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end


end
