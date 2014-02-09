class Geocoding < ActiveRecord::Base

  validates :text, :latitude, :longitude, presence: true

  def self.geocode(text)
    geocoding = find_cached(text) || geocode_and_cache(text)
    [geocoding.latitude, geocoding.longitude]
  end

  def self.find_cached(text)
    where(text: normalize(text)).first
  end

  def self.geocode_and_cache(text)
    result = Geocoder.search(text).first
    if result
      geocoding = find_or_initialize_by(text: normalize(text))
      geocoding.update_attributes(latitude: result.latitude, longitude: result.longitude)
      geocoding
    else
      raise ArgumentError.new("Invalid location: #{text}")
    end
  end

  def self.normalize(text)
    text.squish.downcase
  end

end
