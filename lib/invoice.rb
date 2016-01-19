class Invoice

  attr_reader :id, :customer_id, :merchant_id, :status,:created_at, :updated_at,:merchant, :items, :transactions, :customer

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
    items.reduce(0) do |sum, item|
      sum + item.unit_price*item.quantity
    end.to_f.round(2)
  end

end
