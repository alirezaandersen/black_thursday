class Invoice

  attr_reader :id, :customer_id, :merchant_id, :status, :created_at, :updated_at
  attr_accessor :merchant, :items, :invoice_items, :transactions, :customer

  def initialize(args)
    @id = args[:id].to_i
    @customer_id = args[:customer_id]
    @merchant_id = args[:merchant_id]
    @status = args[:status]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def is_paid_in_full?
    return unless transactions
    transactions.any? {|transaction| transaction.result == "success"}
  end

  def total
    return 0 unless is_paid_in_full?
    return 0 unless invoice_items
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + (invoice_item.unit_price_to_dollars)*(invoice_item.quantity)
    end
  end

  def quantity
    return 0 unless is_paid_in_full?
    return 0 unless invoice_items
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + invoice_item.quantity
    end
  end

end
