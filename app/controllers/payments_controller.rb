class PaymentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def create
    if PaymentService.new(current_user, params).subscribe!
      redirect_to :back
    else
      redirect_to :back, alert: "There was a problem with your subscription. Please try again."
    end
  end
end
