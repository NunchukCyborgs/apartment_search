class Crime
  attr_accessor :location, :offense, :info, :time

  def initialize(location, offense, info, time)
    @location = location
    @offense = offense
    @info = info
    @time = Time.strptime(time, '%H%M')
  end

end
