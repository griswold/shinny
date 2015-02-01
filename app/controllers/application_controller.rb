class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  DEFAULT_LOCATION = "Toronto, ON"

  def current_geolocation
    location = session[:search].try(:[], :location)
    results = Geocoder.search(location)
    results = Geocoder.search(DEFAULT_LOCATION) if results.blank?
    coordinates = results.first.try(:coordinates)
    raise "Cannot find a location" if coordinates.empty?
    coordinates
  end

end
