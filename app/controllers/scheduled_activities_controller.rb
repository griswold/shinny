class ScheduledActivitiesController < ApplicationController
  def index
    @location = params[:location] || "Toronto, ON"
    latitude, longitude = Geocoding.geocode(@location)

    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @time = params[:time].present? ? Time.parse(params[:time]) : Time.zone.now

    start_time = Time.zone.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
    end_time = start_time + 24.hours

    @activity = params[:activity_id].present? ? Activity.find(params[:activity_id]) : Activity.default
    @activities = Activity.all
    @scheduled_activities = ScheduledActivity.where(end_time: start_time..end_time,
                                                    activity: @activity)
                                             .order("start_time asc")
                                             .limit(20)
                                             .includes(:rink, :activity)
  end
end
