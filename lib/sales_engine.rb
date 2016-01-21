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

  def self.from_csv(args)
    se = SalesEngine.new
    args.each do |key, value|
      se.send(key).load_data(value)
    end

    if args[:items] && args[:merchants]
      se.send_items_to_each_merchant
      se.send_merchant_to_all_items
    end
    if args[:merchants] && args[:invoices]
      se.send_invoices_to_each_merchant
      se.send_merchants_to_invoices
    end
    if args[:invoice_items] && args[:invoices]
      se.send_invoice_items_to_each_invoice
    end
    if args[:items] && args[:invoices]
      se.send_items_to_each_invoice
    end
    if args[:transactions] && args[:invoices]
      se.send_transactions_to_each_invoice
      se.send_invoice_to_each_transaction
    end
    if args[:customers] && args[:invoices]
      se.send_customer_to_each_invoice
      se.send_invoices_to_each_customer
    end
    if args[:merchants] && args[:customers]
      se.send_customers_to_each_merchant
      se.send_merchants_to_each_customer
    end
    se
  end

  def self.from_data(args)
    se = SalesEngine.new

    se.items.load_items(args[:items]) if args[:items]
    se.merchants.load_merchants(args[:merchants]) if args[:merchants]
    se.invoices.load_invoices(args[:invoices]) if args[:invoices]
    se.invoice_items.load_invoice_items(args[:invoice_items]) if args[:invoice_items]
    se.customers.load_customers(args[:customers]) if args[:customers]

    if args[:items] && args[:merchants]
      se.send_items_to_each_merchant
      se.send_merchant_to_all_items
    end
    if args[:merchants] && args[:invoices]
      se.send_invoices_to_each_merchant
      se.send_merchants_to_invoices
    end
    if args[:invoice_items] && args[:invoices]
      se.send_invoice_items_to_each_invoice
    end
    if args[:items] && args[:invoices]
      se.send_items_to_each_invoice
    end
    if args[:transactions] && args[:invoices]
      se.send_transactions_to_each_invoice
      se.send_invoice_to_each_transaction
    end
    if args[:customers] && args[:invoices]
      se.send_customer_to_each_invoice
      se.send_invoices_to_each_customer
    end
    if args[:merchants] && args[:customers]
      se.send_customers_to_each_merchant
      se.send_merchants_to_each_customer
    end
    se
  end

  def send_items_to_each_merchant
    merchants.all.each do |merchant|
      merchandise = items.find_all_by_merchant_id(merchant.id).uniq
      merchant.items = merchandise
    end
  end

  def send_merchant_to_all_items
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

  def send_invoices_to_each_merchant
    merchants.all.each do |merchant|
      invs = invoices.find_all_by_merchant_id(merchant.id).uniq
      merchant.invoices = invs
    end
  end

  def send_invoices_to_each_customer
    customers.all.each do |customer|
      invs = invoices.find_all_by_customer_id(customer.id).uniq
      customer.invoices = invs
    end
  end

  def send_items_to_each_invoice
    invoices.all.each do |invoice|
      inv_item_list = invoice_items.find_all_by_invoice_id(invoice.id)
      merchandise = inv_item_list.map do |inv_item|
        items.find_by_id(inv_item.item_id)
      end
      invoice.items = merchandise
    end
  end

  def send_invoice_items_to_each_invoice

    invoices.all.each do |invoice|
      merchandise = invoice_items.find_all_by_invoice_id(invoice.id).uniq
      invoice.invoice_items = merchandise
    end
  end

  def send_transactions_to_each_invoice
    invoices.all.each do |invoice|
      trans = transactions.find_all_by_invoice_id(invoice.id).uniq
      invoice.transactions = trans
    end
  end

  def send_invoice_to_each_transaction
    transactions.all.each do |transaction|
      inv = invoices.find_by_id(transaction.invoice_id)
      transaction.set_invoice(inv)
    end
  end

  def send_customer_to_each_invoice
    invoices.all.each do |invoice|
      cust = customers.find_by_id(invoice.customer_id)
      invoice.customer = cust
    end
  end

  def send_customers_to_each_merchant
    merchants.all.each do |merchant|
      merch_inv_list = invoices.find_all_by_merchant_id(merchant.id)
      customer_list_by_id = merch_inv_list.map {|inv| inv.customer_id}
      cust_list = customer_list_by_id.map {|cust_id| customers.find_by_id(cust_id)}.uniq
      merchant.customers = cust_list
    end
  end

  def send_merchants_to_each_customer
    customers.all.each do |customer|
      invoice_list = invoices.find_all_by_customer_id(customer.id)
      merchant_id_list = invoice_list.map { |invoice| invoice.merchant_id}
      merchant_list = merchant_id_list.map {|merchant_id| merchants.find_by_id(merchant_id)}.uniq
      customer.merchants = merchant_list
    end
  end

end
