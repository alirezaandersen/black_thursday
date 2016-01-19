require 'minitest'

class CustomerAnalyticsTest < Minitest::Test
  def test_get_the_top_buyers
    sa = SalesAnalyst.new
    sa.top_buyers(2)
  end
end
