module WelcomeHelper

  def all_available_prices
    (min_price..max_price).step(100).map { |n| n }
  end

  def min_price
    (@facets[:min_price].to_i / 100).floor * 100 rescue 0
  end

  def max_price
    (@facets[:max_price].to_i / 100).ceil * 100 rescue 10000
  end
end
