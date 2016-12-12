class PaymentFeeService

  def initialize(subtotal)
    @subtotal = subtotal.to_f
  end

  def fees
    @subtotal * 0.05
  end

  def message
    "Roomhere processing fees"
  end
end
