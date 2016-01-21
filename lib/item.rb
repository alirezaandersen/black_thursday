class Item

  attr_reader :name, :description, :unit_price,
              :created_at, :updated_at,
              :id, :merchant_id
  attr_accessor :merchant

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @unit_price = args[:unit_price]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
    @merchant_id = args[:merchant_id]
    @id = args[:id]
  end

  def unit_price_to_dollars
    (unit_price/100.0).to_f.round(2)
  end
end
