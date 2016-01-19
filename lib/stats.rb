module Stats
  def self.average(nums)
    nums.reduce(:+)/(nums.length.to_f)
  end

  def self.sample_variance(nums)
    mean = average(nums)
    sq_diffs = nums.reduce(0) do |sum, num|
      sum + (num-mean)**2
    end
    sq_diffs/(nums.length-1)
  end

  def self.sample_std_dev(nums)
    sample_variance(nums) ** 0.5
  end
end
