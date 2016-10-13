# == Schema Information
#
# Table name: amenities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Amenity < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true

  has_and_belongs_to_many :properties

  def self.pets
    find_or_create_by(name: "Pet Friendly")
  end

  def self.garage
    find_or_create_by(name: "Garage")
  end
end
