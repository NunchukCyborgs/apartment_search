class ClaimPropertyController < ApplicationController
  before_action :set_property

  def index
    redirect_to @property unless @property.unclaimed?
  end

  def create
    if params[:parcel_number] == @property.parcel_number
      @property.update(owner_id: current_user.id)
      redirect_to @property, notice: "Congratulations. You can now manage your property."
    else
      redirect_to action: :index, alert: "Your parcel number was incorrect."
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

end
