class Merchant

  attr_reader :name, :id, :items, :invoices

  def initialize(args)
    @name = args[:name]
    @id = args[:id].to_i
    @invoices = []
  end

  def set_items(items)
    @items = items
  end

  def set_invoices(inv)
    @invoices = inv
  end

end
