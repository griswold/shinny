class Search
  include ActiveModel::Model
  attr_accessor :activity_id, :age, :distance, :gender, :location, :start

  def initialize(params={})
    super
    cast_int(:age, :distance)
    @location = "Toronto, ON" if @location.blank?
  end

  def start_time
    start.present? ? Time.zone.parse(start) : Time.zone.now
  end

  def end_time
    start_time.end_of_day
  end

  def activity
    activity_id.present? ? Activity.find(activity_id) : Activity.default
  end

  def limit
    20
  end

  private

  def cast_int(*attr_names)
    attr_names.each do |name|
      val = send(name).present? ? send(name).to_i : nil
      send("#{name}=", val)
    end
  end

end
