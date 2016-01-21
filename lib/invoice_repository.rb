require 'csv'
require_relative 'invoice'
class InvoiceRepository

  attr_reader :invoices

  def initialize
    @invoices=[]
  end

  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      invoices << Invoice.new({:id => row[:id].to_i,
      :customer_id => row[:customer_id].to_i,
      :merchant_id => row[:merchant_id].to_i,
      :status => row[:status].to_sym,
      :created_at => Time.parse(row[:created_at]),
      :updated_at => Time.parse(row[:updated_at])
      })
      end
  end

  def load_repo_items (invoices_in)
    invoices_in.each do |invoice|
      invoices << invoice
    end
  end

  def find_by_id(id_number)
    invoices.find { |invoice| invoice.id == id_number}
  end

  def find_all_by_customer_id(cust_id)
    invoices.find_all { |invoice| invoice.customer_id == cust_id}
  end

  def find_all_by_merchant_id(merch_id)
    invoices.find_all { |invoice| invoice.merchant_id == merch_id}
  end

  def find_all_by_status(status)
    invoices.find_all { |invoice| invoice.status == status}
  end

  def all
    invoices
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
