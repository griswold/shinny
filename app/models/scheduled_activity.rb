class ScheduledActivity < ActiveRecord::Base

  scope :today, -> { where(start_time: Date.today.beginning_of_day..Date.today.end_of_day).order(:start_time) }

  MALE = "M"
  FEMALE = "F"
  DEFAULT_LOCATION = "Toronto, ON"

  belongs_to :activity
  belongs_to :rink

  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  validates :activity, :rink, :start_time, :end_time, presence: true
  before_save :denormalize_lat_lon

  geocoded_by :address

  def self.search(opts)
    start_time = opts.start_time || Time.zone.today.beginning_of_day
    end_time = opts.end_time || start_time.end_of_day

    scope = where(end_time: start_time..end_time,
                  activity: opts.activity || Activity.default)
            .limit(opts.limit || 20)
            .near(opts.location, @distance || 50, :units => :km)
            .includes(:rink, :activity)
            .order("distance asc, start_time asc")
    scope = scope.where("gender = ? or gender is null", opts.gender) if opts.gender
    if opts.age
      scope = scope.where("start_age is null or start_age <= ?", opts.age)
      scope = scope.where("end_age is null or end_age >= ?", opts.age)
    end
    scope
  end

  def self.conflict_exists?(activity)
    where(rink: activity.rink, start_time: activity.start_time..activity.end_time, original_label: activity.original_label).any?
  end

  def address
    rink.address
  end

  def to_s
    "#{activity.name} @ #{rink.name} : #{start_time} - #{end_time}"
  end

  private

  def denormalize_lat_lon
    if rink
      self.latitude = rink.latitude
      self.longitude = rink.longitude
    end
  end

end
