class Amenity < ActiveRecord::Base
  validates :name, presence: true
end
