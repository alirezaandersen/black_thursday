require 'invoice_items'

class InvoiceItemRepository

  attr_reader :invoices

  def initialize
    @invoices = []
  end

  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      invoices << InvoiceItems.new({:id => row[:id].to_i,
      :item_id => row[:item_id],
      :invoice_id => row[:invoice_id],
      :quantity => row[:quantity],
      :unit_price => row[:unit_price],
      :created_at => Time.parse(row[:created_at]),
      :updated_at => Time.parse(row[:updated_at])
      })
    end
  end

  def load_invoice_items(invoices_in)
    invoices_in.each do |invoice|
      invoices << invoice
    end
  end

  def all
    invoices
  end

  def find_by_id(id_number)
    invoices.find { |invoice| invoice.id == id_number }
  end

  def find_all_by_item_id(item_id)
    invoices.find_all { |invoice| invoice.item_id == item_id}
  end

  def find_all_by_invoice_id(invoice_id)
    invoices.find_all { |invoice| invoice.invoice_id == invoice_id }
  end

end