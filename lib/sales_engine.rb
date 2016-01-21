require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'
require_relative 'invoice_item_repository'

class SalesEngine
  attr_reader :items, :merchants, :invoices, :customers, :transactions, :invoice_items

  def initialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
    @invoices = InvoiceRepository.new
    @customers = CustomerRepository.new
    @transactions = TransactionRepository.new
    @invoice_items = InvoiceItemRepository.new
  end

  def relationships
    [[:items, :merchants], [:merchants, :items],
     [:merchants, :invoices], [:invoices, :merchants],
     [:merchants, :customers], [:customers, :merchants],
     [:customers, :invoices], [:invoices, :customers],
     [:transactions, :invoices], [:invoices, :transactions],
     [:invoice_items, :invoices], [:items, :invoices]]
  end

  def self.from_csv(args)
    se = SalesEngine.new
    args.each do |key, value|
      se.send(key).load_data(value)
    end
    se.transfer_information(args)
    se
  end

  def self.from_data(args)
    se = SalesEngine.new
    args.each do |key, value|
      se.send(key).load_repo_items(value)
    end
    se.transfer_information(args)
    se
  end

  def transfer_information(args)
    relationships.each do |to_send, receiver|
      if args[to_send] && args[receiver]
        send_method = "send_#{to_send}_to_#{receiver}".to_sym
        send(send_method)
      end
    end
  end

  def send_items_to_merchants
    merchants.all.each do |merchant|
      merchandise = items.find_all_by_merchant_id(merchant.id).uniq
      merchant.items = merchandise
    end
  end

  def send_merchants_to_items
    items.all.each do |item|
      merchant = merchants.find_by_id(item.merchant_id)
      item.merchant = merchant
    end
  end

  def send_merchants_to_invoices
    invoices.all.each do |invoice|
      merchant = merchants.find_by_id(invoice.merchant_id)
      invoice.merchant = merchant
    end
  end

  def send_invoices_to_merchants
    merchants.all.each do |merchant|
      invs = invoices.find_all_by_merchant_id(merchant.id).uniq
      merchant.invoices = invs
    end
  end

  def send_invoices_to_customers
    customers.all.each do |customer|
      invs = invoices.find_all_by_customer_id(customer.id).uniq
      customer.invoices = invs
    end
  end

  def send_items_to_invoices
    invoices.all.each do |invoice|
      inv_item_list = invoice_items.find_all_by_invoice_id(invoice.id)
      merchandise = inv_item_list.map do |inv_item|
        items.find_by_id(inv_item.item_id)
      end
      invoice.items = merchandise
    end
  end

  def send_invoice_items_to_invoices

    invoices.all.each do |invoice|
      merchandise = invoice_items.find_all_by_invoice_id(invoice.id).uniq
      invoice.invoice_items = merchandise
    end
  end

  def send_transactions_to_invoices
    invoices.all.each do |invoice|
      trans = transactions.find_all_by_invoice_id(invoice.id).uniq
      invoice.transactions = trans
    end
  end

  def send_invoices_to_transactions
    transactions.all.each do |transaction|
      inv = invoices.find_by_id(transaction.invoice_id)
      transaction.invoice = inv
    end
  end

  def send_customers_to_invoices
    invoices.all.each do |invoice|
      cust = customers.find_by_id(invoice.customer_id)
      invoice.customer = cust
    end
  end

  def send_customers_to_merchants
    merchants.all.each do |merchant|
      merch_inv_list = invoices.find_all_by_merchant_id(merchant.id)
      customer_list_by_id = merch_inv_list.map {|inv| inv.customer_id}
      cust_list = customer_list_by_id.map {|cust_id| customers.find_by_id(cust_id)}.uniq
      merchant.customers = cust_list
    end
  end

  def send_merchants_to_customers
    customers.all.each do |customer|
      invoice_list = invoices.find_all_by_customer_id(customer.id)
      merchant_id_list = invoice_list.map { |invoice| invoice.merchant_id}
      merchant_list = merchant_id_list.map {|merchant_id| merchants.find_by_id(merchant_id)}.uniq
      customer.merchants = merchant_list
    end
  end

end
