class ScheduledActivitiesController < ApplicationController

  before_filter :set_location

  def index
    start_time = params[:date].present? ? Time.zone.parse(params[:date]) : Time.zone.today.beginning_of_day
    end_time = start_time.end_of_day

    @date = start_time.to_date
    @gender = params[:gender] if params[:gender].present?
    @age = params[:age].to_i if params[:age].present?
    @distance = params[:distance].to_i if params[:distance].present?
    @activity = params[:activity_id].present? ? Activity.find(params[:activity_id]) : Activity.default
    @activities = Activity.all

    @scheduled_activities = ScheduledActivity.search start_time: start_time,
                                                     end_time: end_time,
                                                     activity: @activity,
                                                     limit: 20,
                                                     location: @location,
                                                     age: @age,
                                                     gender: @gender,
                                                     distance: @distance

    respond_to do |format|
      format.html
      format.json { render json: @scheduled_activities.to_json(include: :rink) }
    end
  end

  def set_location
    @location = params[:location] || cookies[:location] || "Toronto, ON"
    cookies[:location] = @location
  end
end
