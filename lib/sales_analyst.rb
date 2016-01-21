require_relative 'stats'
require 'pry'
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
    merchants.find_all { |merchant| merchant.items.length < th }
  end

  def merchants_with_high_item_count
    threshold = average_items_per_merchant + average_items_per_merchant_standard_deviation
    merchants.find_all { |merchant| merchant.items.length > threshold }
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

    merchants.find_all { |merchant|
      merchant.invoices.length > threshold }
  end

  def bottom_merchants_by_invoice_count
    threshold = average_invoices_per_merchant - 2*average_invoices_per_merchant_standard_deviation
    merchants.find_all { |merchant|
      merchant.invoices.length < threshold }
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

  def top_buyers(n = 20)
    customers.sort_by do |customer|
      -1*customer.invoice_total
    end[0...n]
  end

  def top_merchant_for_customer(customer_id)
    customer = se.customers.find_by_id(customer_id)
    max_merchant_id = customer.top_merchant_by_item_count
    se.merchants.find_by_id(max_merchant_id)
  end

  def one_time_buyers
    customers.select do |customer|
      customer.fully_paid_invoices.length == 1
    end
  end

  def one_time_buyers_item_counts
    all_invoice_items = one_time_buyers.flat_map do |customer|
      customer.invoice_items
    end
    item_counts = Hash.new(0)
    all_invoice_items.each do |inv_item|
      item_counts[inv_item.item_id] += inv_item.quantity
    end
    item_counts
  end

  def one_time_buyers_item
    item_counts = one_time_buyers_item_counts
    max_count = item_counts.values.max
    max_item_ids = item_counts.keys.select do |item_id|
      item_counts[item_id] == max_count
    end
    max_items = max_item_ids.map { |max_id| se.items.find_by_id(max_id) }
    max_items.sort_by { |item| item.id }
  end

  def most_recently_bought_items(customer_id)
    customer = se.customers.find_by_id(customer_id)
    customer.most_recently_bought_items
  end

  def customers_with_unpaid_invoices
    customers.select do |customer|
      customer.unpaid_invoices.length > 0
    end
  end

  def best_invoice_by_revenue
    invoices.max_by { |invoice| invoice.total }
  end

  def best_invoice_by_quantity
    invoices.max_by { |invoice| invoice.quantity }
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

  def customers
    se.customers.all
  end

end
