class Invoice

  attr_reader :id, :customer_id, :merchant_id, :status,:created_at, :updated_at

  def initialize(args)
    @id = args[:id].to_i
    @customer_id = args[:customer_id]
    @merchant_id = args[:merchant_id]
    @status = args[:status]
    @created_at = Time.now(args[:created_at])
    @updated_at =Time.now( args[:created_at])
  end




end
