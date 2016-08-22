# == Schema Information
#
# Table name: scheduled_events
#
#  id         :integer          not null, primary key
#  event      :string(255)
#  name       :string(255)
#  at         :string(255)
#  frequency  :integer
#  tz         :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ScheduledEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_scheduled_event, only: [:show, :edit, :update, :destroy]

  # GET /scheduled_events
  # GET /scheduled_events.json
  def index
    @scheduled_events = ScheduledEvent.all
  end

  # GET /scheduled_events/1
  # GET /scheduled_events/1.json
  def show
  end

  # GET /scheduled_events/new
  def new
    @scheduled_event = ScheduledEvent.new
  end

  # GET /scheduled_events/1/edit
  def edit
  end

  # POST /scheduled_events
  # POST /scheduled_events.json
  def create
    @scheduled_event = ScheduledEvent.new(scheduled_event_params)

    respond_to do |format|
      if @scheduled_event.save
        format.html { redirect_to @scheduled_event, notice: 'Scheduled event was successfully created.' }
        format.json { render :show, status: :created, location: @scheduled_event }
      else
        format.html { render :new }
        format.json { render json: @scheduled_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduled_events/1
  # PATCH/PUT /scheduled_events/1.json
  def update
    respond_to do |format|
      if @scheduled_event.update(scheduled_event_params)
        format.html { redirect_to @scheduled_event, notice: 'Scheduled event was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled_event }
      else
        format.html { render :edit }
        format.json { render json: @scheduled_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_events/1
  # DELETE /scheduled_events/1.json
  def destroy
    @scheduled_event.destroy
    respond_to do |format|
      format.html { redirect_to scheduled_events_url, notice: 'Scheduled event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scheduled_event
      @scheduled_event = ScheduledEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scheduled_event_params
      params.require(:scheduled_event).permit(:event, :name, :at, :frequency, :tz)
    end
end
