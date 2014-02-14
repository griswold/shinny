class Activity < ActiveRecord::Base

  def self.default
    first
  end

  def self.recognize(string)
    arg_words = extract_words(string)
    all.map do |activity|
      words = extract_words(activity.name)
      [activity, (words & arg_words).size]
    end.sort_by(&:last).last.try(:first)
  end

  def self.extract_words(str)
    str.gsub(/[^\w\s]/, "").squish.downcase.split(/\s+/)
  end

end
