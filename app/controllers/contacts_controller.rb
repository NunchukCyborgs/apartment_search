class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update]

  def show
    render json: { result: "failed" }, status: 404 and return unless @contact.user == current_user
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user
    if @contact.save
      render 'contacts/show', status: :ok
    else
      render json: { result: "failed" }, status: 404
    end
  end

  def update
    if @contact.user == current_user && @contact.update(contact_params)
      render 'contacts/show', status: :ok
    else
      render json: { result: "failed" }, status: 404
    end
  end


  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:email, :phone)
  end
end