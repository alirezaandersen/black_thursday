require_relative 'item'
class ItemRepository

  attr_reader :items

  def initialize
    @items = []
  end

  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      items << Item.new({ :name => row[:name],
        :description => row[:description],
        :unit_price => row[:unit_price],
        :created_at => row[:created_at],
        :updated_at => row[:updated_at],
        :merchant_id => row[:merchant_id],
        :id => row[:id]})
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
      item.unit_price == BigDecimal.new(price, 4)
    end
  end

  def find_all_by_price_in_range(range)
    items.find_all do |item|
      item.unit_price > range.min && item.unit_price < range.max
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


end
