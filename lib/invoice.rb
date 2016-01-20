class Invoice

  attr_reader :id, :customer_id, :merchant_id, :status, :created_at, :updated_at,:merchant, :items, :transactions, :customer, :invoice_items

  def initialize(args)
    @id = args[:id].to_i
    @customer_id = args[:customer_id]
    @merchant_id = args[:merchant_id]
    @status = args[:status]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def set_merchant(merchant_in)
    @merchant = merchant_in
  end

  def set_items(items_in)
    @items = items_in
  end

  def set_invoice_items(invoice_items_in)
    @invoice_items = invoice_items_in
  end

  def set_transactions(transactions_in)
    @transactions = transactions_in
  end

  def set_customer(customer_in)
    @customer = customer_in
  end

  def is_paid_in_full?
    transactions.any? {|transaction| transaction.result == "success"}
  end

  def total
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + (invoice_item.unit_price_to_dollars)*(invoice_item.quantity)
    end
  end

end
