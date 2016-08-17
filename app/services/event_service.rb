class EventService

  def initialize(event)
    @event = event
  end

  def process
    case @event.event
    when 'emergency.notify.am'
      Delayed::Job.enqueue EmergencyNotifyAmJob.new
    when 'emergency.notify.pm'
      Delayed::Job.enqueue EmergencyNotifyPmJob.new
    else
      Rails.logger.error('UNKNOWN EVENT')
    end
  end
end
