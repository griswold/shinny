class ScheduledActivitiesController < ApplicationController
  def index
    start_time = Time.now
    end_time = start_time + 24.hours
    @location = params[:location] || "Toronto, ON"
    latitude, longitude = Geocoding.geocode(@location)
    @activity = params[:activity_id].present? ? Activity.find(params[:activity_id]) : Activity.default
    @activities = Activity.all
    @scheduled_activities = ScheduledActivity.where(end_time: start_time..end_time,
                                                    activity: @activity)
                                             .order("start_time asc")
                                             .limit(20)
                                             .includes(:rink, :activity)
  end
end
