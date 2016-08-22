# == Schema Information
#
# Table name: amenities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon       :string(255)
#

class Amenity < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true

  has_and_belongs_to_many :properties
end
