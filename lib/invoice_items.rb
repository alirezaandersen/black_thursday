class InvoiceItems

  attr_reader :id, :item_id, :invoice_id,
  :quantity, :unit_price, :created_at, :updated_at

  def initialize(args)
    @id = args[:id].to_i
    @item_id = args[:item_id]
    @invoice_id = args[:invoice_id]
    @quantity = args[:quantity].to_i
    @unit_price = args[:unit_price]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def unit_price_to_dollars
  (unit_price*quantity).to_f.round(2)
end


end
