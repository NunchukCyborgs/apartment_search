require 'rails_helper'
require 'json'

describe "Payment Request Processing", type: :request do
  let!(:property) { Property.create(address1: "123 Test St", bedrooms: 4, bathrooms: 2.5, ) }
  let!(:user) { User.create(email: "123@test.com", password: "abc123", password_confirmation: "abc123", confirmed_at: DateTime.now) }
  let!(:headers) { user.create_new_auth_token }
  let(:potential_address) { "123 Property Management St." }
  let(:name) { "Testy McTesterson" }
  let(:subtotal) { 500.00 }
  let(:due_on) { Date.today }
  let(:contact_email) { "management@property.com" }
  let(:contact_phone) { "111-111-1111" }

  it "creates a payment request with all pertinate info" do
    post "/payments/request", payment_request: { property_id: property.id,
                                                 potential_address: potential_address,
                                                 due_on: due_on,
                                                 name: name,
                                                 subtotal: subtotal,
                                                 contact_attributes: {
                                                   email: contact_email,
                                                   phone: contact_phone
                                                 }
                                               }, headers: headers

    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body[:id]).to_not be_nil
    property_request = PropertyRequest.find(json_body[:id])

    expect(property_request).to_not be_nil
    expect(property_request.name).to eq(name)
    expect(property_request.potential_address).to eq(potential_address)
    expect(propert_request.due_on).to eq(due_on)
    expect(property_request.subtotal).to eq(subtotal)
    expect(property_request.contact.email).to eq(contact_email)
    expect(propert_request.contact.phone).to eq(contact_phone)
  end
end
