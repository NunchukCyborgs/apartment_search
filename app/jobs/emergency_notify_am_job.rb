class EmergencyNotifyAmJob

  def perform
    EmergencyParser.new("AM").process
  end

end
