class RatingUpdateJob

  def initialize(property_id)
    @property_id = property_id
    @property = Property.friendly.find(@property_id)
  end

  def perform
    update_averages
  end

  private

  def update_averages
    update_landlord_rating
    update_property_rating
    update_combined_rating
  end

  def update_landlord_rating
    avg = license.reviews.validated.average(:landlord_rating)
    license.update_attributes!(average_landlord_rating: avg)
  end

  def update_property_rating
    avg = @property.reviews.validated.average(:property_rating)
    @property.update_attributes!(average_property_rating: avg)
  end

  # used for sorting results, combined weighted averages for property/landlord
  def update_combined_rating
    property_weight, landlord_weight = 1, 1
    weighted_property_rating = property_weight * property.average_property_rating
    weighted_landlord_rating = landlord_weight * license.average_landlord_rating
    combined_avg = (weighted_property_rating + weighted_landlord_rating) / 2
    @property.update_attributes!(average_combined_rating: combined_avg)
  end

  def license
    @license ||= @property.license
  end
end
