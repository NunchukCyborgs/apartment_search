module WelcomeHelper

  def available_prices
    min_price = (@facets[:min_price].to_i / 100).floor * 100
    max_price = (@facets[:min_price].to_i / 100).ceil * 100
    (min_price..max_price).step(100).map { |n| n }
  end
end
