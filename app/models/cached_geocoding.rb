# implements methods specified by the geocoder gem's caching docs
# https://github.com/alexreisner/geocoder#caching
class CachedGeocoding < ActiveRecord::Base

  validates :text, :response, presence: true

  def self.geocode(text)
    geocoding = find_cached(text) || geocode_and_cache(text)
    [geocoding.latitude, geocoding.longitude]
  end

  def self.[](text)
    where(text: normalize(text)).first.try(:response)
  end

  def self.[]=(key, value)
    normalized_key = normalize(key)
    geocoding = find_or_initialize_by(text: normalized_key)
    geocoding.update_attributes(text: normalized_key, response: value)
    value
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
