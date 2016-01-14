class Merchant

  attr_reader :name, :id, :items

  def initialize(args)
    @name = args[:name]
    @id = args[:id].to_i
  end

  def set_items(items)
    @items = items
  end

end
