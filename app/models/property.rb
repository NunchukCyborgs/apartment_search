class Property < ActiveRecord::Base
  validates :address1, :zipcode, :price, :lease_length, presence: true

  #for contact_number contact_email, maybe we default back to these properties
  #on the owner if they have not entered them for the property 


end
