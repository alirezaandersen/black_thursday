class Item

  attr_reader :name, :description, :unit_price, :created_at, :updated_at, :id, :merchant_id

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @unit_price = BigDecimal(args[:unit_price],4)
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
    @merchant_id = args[:merchant_id].to_i
    @id = args[:id].to_i
  end

end
