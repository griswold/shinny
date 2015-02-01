class ScheduledActivitiesController < ApplicationController

  before_filter :set_location

  def index
    @activities = Activity.all

    @search = Search.new(params[:search])

    @scheduled_activities = ScheduledActivity.search start_time: @search.start_time,
                                                     end_time: @search.end_time,
                                                     activity: @search.activity,
                                                     limit: @search.limit,
                                                     location: @search.location,
                                                     age: @search.age,
                                                     gender: @search.gender,
                                                     distance: @search.distance

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
