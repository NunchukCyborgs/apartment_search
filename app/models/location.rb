class Location < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :full_name, :facet_name, :data_name, presence: true
end
