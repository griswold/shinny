class Activity < ActiveRecord::Base

  def self.default
    first
  end

  def self.recognize(string)
    arg_words = string.squish.downcase.split(/\s+/)
    all.map do |activity|
      words = activity.name.squish.downcase.split(/\s+/)
      [activity, (words & arg_words).size]
    end.sort_by(&:last).last.try(:first)
  end

end
