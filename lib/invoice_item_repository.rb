require 'csv'
require 'invoice_items'

class InvoiceItemRepository

  attr_reader :invoice_items

  def initialize
    @invoice_items = []
  end

  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      invoice_items << InvoiceItem.new({:id => row[:id].to_i,
      :item_id => row[:item_id].to_i,
      :invoice_id => row[:invoice_id].to_i,
      :quantity => row[:quantity].to_i,
      :unit_price => BigDecimal.new(row[:unit_price]),
      :created_at => Time.parse(row[:created_at]),
      :updated_at => Time.parse(row[:updated_at])
      })
    end
  end

  def load_repo_items(invoice_items_in)
    invoice_items_in.each { |invoice_item| invoice_items << invoice_item }
  end

  def all
    invoice_items
  end

  def find_by_id(id_number)
    invoice_items.find { |invoice_item| invoice_item.id == id_number }
  end

  def find_all_by_item_id(item_id)
    invoice_items.find_all { |invoice_item| invoice_item.item_id == item_id}
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_items.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
