app_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

require 'clockwork'
require 'clockwork/database_events'

require_relative File.expand_path('../../config/boot',        __FILE__)
require_relative File.expand_path('../../config/environment', __FILE__)

module Clockwork
  # required to enable database syncing support
  Clockwork.manager = DatabaseEvents::Manager.new

  sync_database_events model: ScheduledEvent, every: 1.minute do |event|
    EventService.new(event).process
  end
  every(1.day, 'test.log', :at => '01:30') { Rails.logger.info("clockwork out....") }

end
