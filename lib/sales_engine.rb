require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'

class SalesEngine
  attr_reader :items, :merchants, :invoices
  def initialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
    @invoices = InvoiceRepository.new
  end

  def self.from_csv(args)
    se = SalesEngine.new
    se.items.load_data(args[:items]) if args[:items]
    se.merchants.load_data(args[:merchants]) if args[:merchants]
    se.invoices.load_data(args[:invoices]) if args[:invoices]
    if args[:items] && args[:merchants]
      se.send_items_to_each_merchant
      se.send_merchant_to_all_items
    end
    if args[:merchants] && args[:invoices]
      se.send_invoices_to_each_merchant
      se.send_merchants_to_invoices
    end
    se
  end

  def self.from_data(args)
    se = SalesEngine.new
    se.items.load_items(args[:items]) if args[:items]
    se.merchants.load_merchants(args[:merchants]) if args[:merchants]
    se.invoices.load_invoices(args[:invoices]) if args[:invoices]
    if args[:items] && args[:merchants]
      se.send_items_to_each_merchant
      se.send_merchant_to_all_items
    end
    if args[:merchants] && args[:invoices]
      se.send_invoices_to_each_merchant
      se.send_merchants_to_invoices
    end
    se
  end

  def send_items_to_each_merchant
    merchants.all.each do |merchant|
      merchandise = items.find_all_by_merchant_id(merchant.id)
      merchant.set_items(merchandise)
    end
  end

  def send_merchant_to_all_items
    items.all.each do |item|
      merchant = merchants.find_by_id(item.merchant_id)
      item.set_merchant(merchant)
    end
  end

  def send_merchants_to_invoices
    invoices.all.each do |invoice|
      merchant = merchants.find_by_id(invoice.merchant_id)
      invoice.set_merchant(merchant)
    end
  end

  def send_invoices_to_each_merchant
    merchants.all.each do |merchant|
      invoice = invoices.find_all_by_merchant_id(merchant.id)
      merchant.set_invoices(invoice)
    end
  end

end
