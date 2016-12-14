class PropertyRequestJob

  def initialize(property_request_id)
    @property_request_id = property_request_id
  end

  def perform
    property_request = PropertyRequest.find(@property_request_id)
    SlackNotificationService.new.post("#{property_request.contact_email} created a request for a property @ #{property_request.address}. Follow up is needed!")
  end
end
