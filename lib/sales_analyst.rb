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

  def merchants_with_high_item_count
    se.merchants.all.find_all do |merchant|
      merchant.items.length > average_items_per_merchant + average_items_per_merchant_standard_deviation
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
    return 0 if items.length == 0
    sum = items.reduce(0) do |total, item|
      total + item.unit_price unless item.nil?
    end
    (sum/100.0/items.length).round(2)
  end

  def average_average_price_per_merchant
    #ensemble
    total_merch = total_number_of_merchants
    merchants = se.merchants.all
    avg_prices_sum = merchants.reduce(0) do |sum, merchant|
      sum + average_item_price_for_merchant(merchant.id)
    end
    (avg_prices_sum/total_merch).round(2)
  end

  def total_number_of_merchants
    se.merchants.all.length
  end

  def prices_variance
    m = average_average_price_per_merchant
    sum = se.items.all.inject(0){|accum, item| accum + (item.unit_price/100.0-m)**2 }
    sum/(se.items.all.length-1).to_f
  end

  def prices_std_deviation
    Math.sqrt(prices_variance)
  end

  def golden_items
    average = average_average_price_per_merchant
    std_dev = prices_std_deviation
    threshold = average + std_dev * 2
    items = se.items.all
    items.select {|item| item.unit_price_to_dollars > threshold}
  end

  def average_invoices_per_merchant
    sum = merchants.reduce(0) do |total, merchant|
      total + merchant.invoices.count
    end
    (sum/merchants.length.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
      m = average_invoices_per_merchant
      sum = 0
      merchants.each do |merchant|
        sum += (merchant.invoices.length - m)**2
      end
      sum/(merchants.length - 1)
    Math.sqrt(sum/(merchants.length - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    merchants.find_all do |merchant|
      merchant.invoices.length > average_invoices_per_merchant + 2 * average_invoices_per_merchant_standard_deviation
    end
  end

  def bottom_merchants_by_invoice_count
    merchants.find_all do |merchant|
      merchant.invoices.length < average_invoices_per_merchant - 2 * average_invoices_per_merchant_standard_deviation
    end
  end


  def merchants
    se.merchants.all
  end

  def top_days_by_invoice_count
    invoice_days = invoices.map {|invoice| Date::DAYNAMES[invoice.created_at.wday]}

    weekday_count = []
    (0..7).each do |i|
      weekday_count[i] = invoice_days.select {|day| day == Date::DAYNAMES[i]}.length
    end

    mean_invoices_per_day = invoices.length/7.0
    sum = weekday_count.reduce(0) do |accum, wdcount|
      accum + (wdcount-mean_invoices_per_day)**2
    end
    std_dev = Math.sqrt(sum/6.0)

    top_days = []
    weekday_count.each_with_index do |wdcount,i|
      top_days << Date::DAYNAMES[i] if wdcount > mean_invoices_per_day +std_dev
    end
    top_days

  end

  def invoice_status(status)
    status = status.to_s
    invs = se.invoices.find_all_by_status(status)
    ((invs.length.to_f)/(invoices.length)*100).round(2)
  end

  def invoices
    se.invoices.all
  end

end
