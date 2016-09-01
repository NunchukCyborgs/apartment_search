class ImageCreateService

  def initialize(property, files)
    @property = property
    @files = files
  end

  def process
    @files.each do |image|
      @property.images << Image.create(file: image)
    end
    @property.save
  end
end
