require 'minitest'
require 'stats'
class StatsTest < Minitest::Test
  def test_average_calculation
    nums = [3, 4, 8, 9, 25, 14, 1]
    assert_equal 9.14, Stats.average(nums).to_f.round(2)
  end

  def test_sample_variance
    nums = [3, 4, 8, 9, 25, 14, 1]
    assert_equal 9.14, Stats.average(nums).to_f.round(2)
    assert_equal 67.81, Stats.sample_variance(nums).to_f.round(2)
  end

  def test_sample_standard_deviation
    nums = [3, 4, 8, 9, 25, 14, 1]
    assert_equal 9.14, Stats.average(nums).to_f.round(2)
    assert_equal 67.81, Stats.sample_variance(nums).to_f.round(2)
    assert_equal 8.23, Stats.sample_std_dev(nums).to_f.round(2)
  end
end
