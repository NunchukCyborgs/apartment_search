# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  full_name  :string(255)
#  facet_name :string(255)
#  data_name  :string(255)
#  latitude   :float(24)
#  longitude  :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :full_name, :facet_name, :data_name, presence: true
end
