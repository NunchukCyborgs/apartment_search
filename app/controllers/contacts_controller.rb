class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update]
  authorize_resource except: [:create_with_license]
  skip_authorization_check only: [:create_with_license]

  def show
    render json: { result: "failed" }, status: 404 and return unless @contact.user == current_user
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.contactable = current_user
    if @contact.save
      render 'contacts/show', status: :ok
    else
      render json: { result: "failed" }, status: 404
    end
  end

  def create_with_license
    render json: { result: "failed" }, status: 404 and return unless current_user.has_role? :superuser
    @license = License.find_by(value: params[:license_id])
    @license.contacts << Contact.create(contact_params)
    render 'licensing/show', status: :ok
  end

  def update
    if @contact.update(contact_params)
      render 'contacts/show', status: :ok
    else
      render json: { result: "failed" }, status: 400
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
