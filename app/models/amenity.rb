class Amenity < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true

  has_and_belongs_to_many :properties
end
