class ScheduledActivitiesController < ApplicationController
  def index
    @location = params[:location] || "Toronto, ON"
    latitude, longitude = Geocoding.geocode(@location)

    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @time = params[:time].present? ? Time.parse(params[:time]) : Time.zone.now

    start_time = Time.zone.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
    end_time = start_time + 24.hours

    @gender = params[:gender] if params[:gender].present?
    @age = params[:age].to_i if params[:age].present?

    @activity = params[:activity_id].present? ? Activity.find(params[:activity_id]) : Activity.default
    @activities = Activity.all

    @scheduled_activities = ScheduledActivity.where(end_time: start_time..end_time,
                                                    activity: @activity)
                                             .order("start_time asc")
                                             .limit(20)
                                             .includes(:rink, :activity)
    @scheduled_activities = @scheduled_activities.where("gender = ? or gender is null", @gender) if @gender
    if @age
      @scheduled_activities = @scheduled_activities.where("start_age is null or start_age <= ?", @age)
      @scheduled_activities = @scheduled_activities.where("end_age is null or end_age >= ?", @age)
    end
  end
end
