# implements methods specified by the geocoder gem's caching docs
# https://github.com/alexreisner/geocoder#caching
class CachedGeocoding < ActiveRecord::Base

  validates :text, :response, presence: true

  def self.[](text)
    where(text: normalize(text)).first.try(:response)
  end

  def self.[]=(key, value)
    normalized_key = normalize(key)
    geocoding = find_or_initialize_by(text: normalized_key)
    geocoding.update_attributes(text: normalized_key, response: value)
    value
  end

  def self.normalize(text)
    text.squish.downcase
  end

end
