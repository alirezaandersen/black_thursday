class Customer

  attr_reader :id, :first_name, :last_name, :created_at, :updated_at, :merchants, :invoices

  def initialize(args)
    @id = args[:id].to_i
    @first_name = args[:first_name].capitalize
    @last_name = args[:last_name].capitalize
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def set_merchants(merch_in)
    @merchants = merch_in
  end

  def set_invoices(invoices_in)
    @invoices = invoices_in
  end

  def invoice_items
    fully_paid_invoices.flat_map { |invoice| invoice.invoice_items }
  end

  def fully_paid_invoices
    invoices.select {|invoice| invoice.is_paid_in_full? }
  end

  def unpaid_invoices
    invoices.reject {|invoice| invoice.is_paid_in_full? }
  end
end
