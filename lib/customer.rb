class Customer

  attr_reader :id, :first_name, :last_name, :created_at, :updated_at
  attr_accessor :merchants, :invoices

  def initialize(args)
    @id = args[:id].to_i
    @first_name = args[:first_name].capitalize
    @last_name = args[:last_name].capitalize
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
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

  def invoice_total
    fully_paid_invoices.reduce(0) {|sum, invoice| sum + invoice.total }
  end

end
