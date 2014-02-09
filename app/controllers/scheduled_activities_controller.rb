class ScheduledActivitiesController < ApplicationController
  def index
    start_time = Time.now
    end_time = Time.now.end_of_day
    @scheduled_activities = ScheduledActivity.search(start_time, end_time)
  end
end
