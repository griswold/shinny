class RinksController < ApplicationController
  def index
    @rinks = Rink.ordered
  end

  def show
    @rink = Rink.find(params[:id])
    @scheduled_activities = @rink.scheduled_activities.today
  end
end
