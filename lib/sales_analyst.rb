class SalesAnalyst

  attr_reader :se

  def initialize(se)
    @se = se
  end

  def sales_engine
    se
  end

  def average_items_per_merchant
    num_merchants = total_number_of_merchants
    sum = total_items_from_all_merchants
    (sum/num_merchants.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    Math.sqrt(items_variance).round(2)
  end

  def merchants_with_low_item_count
    se.merchants.all.find_all do |merchant|
      merchant.items.length < average_items_per_merchant - average_items_per_merchant_standard_deviation
    end
  end

  def total_number_of_merchants
    se.merchants.all.length
  end

  def total_items_from_all_merchants
    sum = 0
    se.merchants.all.each do |merchant|
      sum += merchant.items.length
    end
    sum
  end

  def items_variance
    m = average_items_per_merchant
    sum = se.merchants.all.reduce(0) do |accum, merchant|
      accum + (merchant.items.length-m)**2
    end
    sum/((se.merchants.all.length-1).to_f)
  end

  def average_item_price_for_merchant(merchant_id)
    # individual merchant
    merchant = se.merchants.find_by_id(merchant_id)
    items = merchant.items
    sum = items.reduce(0) do |total, item|
      total + item.unit_price
    end
    (sum/items.length.to_f).round(2)
  end

  def average_price_per_merchant
    #ensemble
    total_merch = total_number_of_merchants
    merchants = se.merchants.all
    avg_prices_sum = merchants.reduce(0) do |sum, merchant|
      sum + average_item_price_for_merchant(merchant.id)
    end
    (avg_prices_sum/total_merch.to_f).round(2)
  end

  def total_number_of_merchants
    se.merchants.all.length
  end

  def prices_variance
    m = average_price_per_merchant
    sum = se.items.all.inject(0){|accum, item| accum + (item.unit_price-m)**2 }
    sum/(se.items.all.length-1).to_f
  end

  def prices_std_deviation
    Math.sqrt(prices_variance)
  end

  def golden_items
    average = average_price_per_merchant
    std_dev = prices_std_deviation
    threshold = average + std_dev * 2
    items = se.items.all
    items.select {|item| item.unit_price > threshold}
  end

end
