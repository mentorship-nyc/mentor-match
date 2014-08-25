class Profile < ActiveRecord::Base

  AVAILABILITIES = [
    'weekly', 'bi-weekly', 'weekends', 'week-nights', 'open'
  ]

  after_create do |model|
    MentorMatch::Slack.advertise_profile(model)
  end

  validates :bio,          length: {maximum: 500}, allow_blank: false
  validates :availability, inclusion: {in: AVAILABILITIES}
  validates :skills,       length: {maximum: 255, minimum: 5}, allow_blank: false

  belongs_to :user

  def availability_matches
    if availability == 'open'
      AVAILABILITIES
    elsif AVAILABILITIES[0..2].include? availability
      AVAILABILITIES[0..2]
    elsif availability == 'weekends'
      AVAILABILITIES[3]
    end
  end

  def matches
    Profile.includes(:user).
      where(availability: availability_matches).
      where(role: opposite_role).
      where.not(id: id).
      limit(20)
  end

  def name
    user.name
  end

  def nickname
    user.github.nickname
  end

  def opposite_role
    role ? 'student' : 'mentor' : 'student'
  end
end
