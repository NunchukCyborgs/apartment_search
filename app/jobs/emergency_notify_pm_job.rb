class EmergencyNotifyPmJob

  def perform
    EmergencyParser.new("PM").process
  end

end
