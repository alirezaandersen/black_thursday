require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine
  attr_reader :items, :merchants
  def initialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
  end

  def self.from_csv(args)
    se = SalesEngine.new
    se.items.load_data(args[:items])
    se.merchants.load_data(args[:merchants])
    se.send_items_to_each_merchant
    se.send_merchant_to_all_items
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

end
