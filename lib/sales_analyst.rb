require_relative 'stats'
class SalesAnalyst

  attr_reader :se

  def initialize(se)
    @se = se
  end

  def average_items_per_merchant
    items_per_merchant = merchants.map {|merchant| merchant.items.length}
    Stats.average(items_per_merchant).to_f.round(2)
  end

  def average_items_per_merchant_standard_deviation
    items_per_merchant = merchants.map {|merchant| merchant.items.length}
    Stats.sample_std_dev(items_per_merchant).to_f.round(2)
  end

  def merchants_with_low_item_count
    th=average_items_per_merchant-average_items_per_merchant_standard_deviation
    merchants.find_all do |merchant|
      merchant.items.length < th
    end
  end

  def merchants_with_high_item_count
    threshold = average_items_per_merchant + average_items_per_merchant_standard_deviation
    merchants.find_all do |merchant|
      merchant.items.length > threshold
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = se.merchants.find_by_id(merchant_id)
    return 0 if merchant.items.length == 0
    merchandise_prices = merchant.items.map {|item| item.unit_price_to_dollars}
    Stats.average(merchandise_prices).round(2)
  end

  def average_average_price_per_merchant
    average_price_per_merchant = merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    Stats.average(average_price_per_merchant).round(2)
  end

  def prices_variance
    m = average_average_price_per_merchant
    sum = items.inject(0){|accum, item| accum + (item.unit_price_to_dollars-m)**2 }
    sum/(items.length-1)
  end

  def prices_std_dev
    Math.sqrt(prices_variance)
  end

  def golden_items
    threshold = average_average_price_per_merchant + 2 * prices_std_dev
    items.find_all {|item| item.unit_price_to_dollars > threshold}
  end

  def average_invoices_per_merchant
    invoices_per_merchant = merchants.map {|merchant| merchant.invoices.length}
    Stats.average(invoices_per_merchant).to_f.round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    invoices_per_merchant = merchants.map {|merchant| merchant.invoices.length}
    Stats.sample_std_dev(invoices_per_merchant).to_f.round(2)
  end

  def top_merchants_by_invoice_count
    threshold = average_invoices_per_merchant + 2*average_invoices_per_merchant_standard_deviation

    merchants.find_all do |merchant|
      merchant.invoices.length > threshold
    end
  end

  def bottom_merchants_by_invoice_count
    threshold = average_invoices_per_merchant - 2*average_invoices_per_merchant_standard_deviation
    merchants.find_all do |merchant|
      merchant.invoices.length < threshold
    end
  end

  def get_invoice_counts_by_day
    weekday_counts = [0]*7
    invoices.each do |invoice|
      weekday_counts[invoice.created_at.wday] += 1
    end
    weekday_counts
  end

  def top_days_by_invoice_count
    weekday_counts = get_invoice_counts_by_day
    threshold = (Stats.average(weekday_counts) + Stats.sample_std_dev(weekday_counts))
    top_days = []
    weekday_counts.each_with_index do |wdcount,i|
      top_days << Date::DAYNAMES[i] if wdcount > threshold
    end
    top_days
  end

  def invoice_status(status)
    invs_count = se.invoices.find_all_by_status(status).length
    ((invs_count.to_f)/(invoices.length)*100).round(2)
  end

  def invoices
    se.invoices.all
  end

  def merchants
    se.merchants.all
  end

  def items
    se.items.all
  end

end
