class ScheduledActivitiesController < ApplicationController
  def index
    start_time = Time.now
    end_time = Time.now.end_of_day
    @activity = Activity.find(params[:activity_id]) || Activity.default
    @activities = Activity.all
    @scheduled_activities = ScheduledActivity.where(end_time: start_time..end_time,
                                                    activity: @activity)
                                             .order("start_time asc")
                                             .limit(20)
                                             .includes(:rink, :activity)
  end
end
