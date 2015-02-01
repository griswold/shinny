class ScheduledActivitiesController < ApplicationController

  after_filter :remember_search_params_for_next_time

  def index
    @activities = Activity.all

    search_params = params[:search] || session[:search] || {}

    @search = Search.new(search_params)

    @scheduled_activities = ScheduledActivity.search(@search)

    respond_to do |format|
      format.html
      format.json { render json: @scheduled_activities.to_json(include: :rink) }
    end
  end

  private

  def remember_search_params_for_next_time
    if @search.remember?
      session[:search] = @search.to_remember
    end
  end
end
