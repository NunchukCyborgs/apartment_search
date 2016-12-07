class Devise::ConfirmationsController < DeviseTokenAuth::ConfirmationsController

  def show
    super do |user|
      if params[:payment_token]
        PaymentRetrievalService.new(params[:payment_token], user).update!
      end
    end
  end
end
