class Item

  attr_reader :name, :description, :unit_price,
              :created_at, :updated_at,
              :id, :merchant_id, :merchant

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @unit_price = args[:unit_price]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
    @merchant_id = args[:merchant_id].to_i
    @id = args[:id].to_i
  end

  def set_merchant(merchant)
    @merchant = merchant
  end

end
