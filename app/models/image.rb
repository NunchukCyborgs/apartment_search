# == Schema Information
#
# Table name: images
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  imageable_id      :integer
#  imageable_type    :string(255)
#  height            :string(255)
#  width             :string(255)
#
# Indexes
#
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  before_create :extract_dimensions

  has_attached_file :file, default_url: "http://placehold.it/600x400",
    styles: lambda { |a|
      Rails.logger.info("------------------------")
      Rails.logger.info("gahhh: #{a.instance.width}x#{a.instance.height}#")
      Rails.logger.info("------------------------")
      {
        thumb: "64x64#",
        medium: "600x400#",
        original_compressed: "#{a.instance.width}x#{a.instance.height}#"
      }
    },
    convert_options: {
      original_compressed: "-quality 75 -strip"
    }
    processors: [:thumbnail, :compression]
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  delegate :url, to: :file, prefix: false

  def extract_dimensions
    tempfile = file.queued_for_write[:original]
    unless tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      self.height = geometry.height.to_i
      self.width = geometry.width.to_i
    end
  end
end
