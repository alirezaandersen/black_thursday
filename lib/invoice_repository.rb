class InvoiceRepository

  attr_reader :invoices

  def initialize
    @invoices=[]
  end

  # def load_data(filename)
  #   data = CSV.open filename, headers: true, header_converters: :symbol
  #
  #   data.each do |row|
  #     items << Item.new({:name => row[:name].to_s,
  #       :description => row[:description].to_s,
  #       :unit_price => BigDecimal.new(row[:unit_price]),
  #       :created_at => Time.parse(row[:created_at]),
  #       :updated_at => Time.parse(row[:updated_at]),
  #       :merchant_id => row[:merchant_id].to_i,
  #       :id => row[:id].to_i})
  #     end
  # end

  def load_invoices(invoices_in)
    invoices_in.each do |invoice|
      invoices << invoice
    end
  end

  def find_by_id(id_number)
    invoices.find { |invoice| invoice.id == id_number}
  end

  def all
    invoices
  end
end
