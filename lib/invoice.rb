class Invoice

  attr_reader :id, :customer_id, :merchant_id, :status,:created_at, :updated_at,:merchant

  def initialize(args)
    @id = args[:id].to_i
    @customer_id = args[:customer_id]
    @merchant_id = args[:merchant_id]
    @status = args[:status]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def set_merchant(merchant)
    @merchant = merchant
  end

end
