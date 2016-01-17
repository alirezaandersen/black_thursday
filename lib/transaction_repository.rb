require 'transaction'
require 'invoice_items'


class TransactionRepository

  attr_reader :transactions


  def initialize
    @transactions = []
  end


  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      transactions << Transaction.new( {:id => row[:id].to_i,
      :invoice_id => row[:invoice_id],
      :credit_card_number => row[:credit_card_number],
      :credit_card_expiration_date => row[:credit_card_expiration_date],
      :result => row[:result],
      :created_at => Time.parse(row[:created_at]),
      :updated_at => Time.parse(row[:updated_at])
      } )
    end
  end

  def load_transactions(trans)
    trans.each do |invoice|
      transactions << invoice
    end
  end

  def all
    transactions
  end

  def find_by_id(id_number) #should it be invoice item #
    transactions.find { |invoice| invoice.id == id_number }
  end

  def find_all_by_invoice_id(invoice_num)
    transactions.find_all { |invoice| invoice.invoice_id == invoice_num }
  end

  def find_all_by_credit_card_number(cc_num)
    transactions.find_all { |invoice| invoice.credit_card_number == cc_num }
  end

  def find_all_by_result(status)
    transactions.find_all { |invoice| invoice.result == status }
  end

end
