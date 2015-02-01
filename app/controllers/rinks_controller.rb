class RinksController < ApplicationController
  def index
    @rinks = Rink.ordered
  end

  def show
    @rink = Rink.find(params[:id])
    @scheduled_activities = @rink.scheduled_activities.today
    @lat, @lon = current_geolocation()
    @distance = (Geocoder::Calculations.distance_between([@lat, @lon], [@rink.latitude, @rink.longitude]) * 1.609).round(1)
  end
end
