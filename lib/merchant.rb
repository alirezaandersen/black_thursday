class Merchant

  attr_reader :name, :id
  attr_accessor :items, :invoices, :customers

  def initialize(args)
    @name = args[:name]
    @id = args[:id].to_i
    @invoices = []
  end

end
