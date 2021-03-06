require 'transaction'

class TransactionRepository

  attr_reader :transactions
  def initialize
    @transactions = []
  end


  def load_data(filename)
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      transactions << Transaction.new( {:id => row[:id].to_i,
      :invoice_id => row[:invoice_id].to_i,
      :credit_card_number => row[:credit_card_number].to_i,
      :credit_card_expiration_date => row[:credit_card_expiration_date],
      :result => row[:result],
      :created_at => Time.parse(row[:created_at]),
      :updated_at => Time.parse(row[:updated_at])
      } )
    end
  end

  def load_repo_items(trans_in)
    trans_in.each do |transaction|
      transactions << transaction
    end
  end

  def all
    transactions
  end

  def find_by_id(id_number)
    transactions.find { |transaction| transaction.id == id_number }
  end

  def find_all_by_invoice_id(invoice_num)
    transactions.find_all do |transaction|
      transaction.invoice_id == invoice_num
    end
  end

  def find_all_by_credit_card_number(cc_num)
    transactions.find_all do |transaction|
      transaction.credit_card_number == cc_num
    end
  end

  def find_all_by_result(status)
    transactions.find_all { |transaction| transaction.result == status }
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
