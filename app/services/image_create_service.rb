class ImageCreateService

  def initialize(property, files)
    @property = property
    @files = files
    Rails.logger.info @files.inspect
  end

  def process
    @files.each do |image|
      @property.images << Image.create(file: image)
    end
    @property.save
  end
end
