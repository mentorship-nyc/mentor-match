class Profile < ActiveRecord::Base

  AVAILABILITIES = ['weekly', 'bi-weekly', 'weekends', 'week-nights', 'open']
  ROLES = ['student', 'mentor']

  after_create do |model|
    MentorMatch::Slack.advertise_profile(model)
    MentorMatch::UserMailer.signup(model.user.name, model.user.email, model.role)
  end

  validates :bio,          length: {maximum: 500}, allow_blank: false
  validates :availability, inclusion: {in: AVAILABILITIES}
  validates :skills,       length: {maximum: 255, minimum: 5}, allow_blank: false
  validates :role,         inclusion: {in: ROLES}

  validates :name,         length: {maximum: 100}, allow_blank: false
  validates :image,        length: {maximum: 255}, allow_blank: false
  validates :location,     length: {maximum: 100}, allow_blank: false
  #validates :country,      length: {maximum: 50},  allow_blank: false
  #validates :timezone,     length: {maximum: 50},  allow_blank: false
  #validates :active,        inclusion: {in: [true, false]}

  belongs_to :user

  def availability_matches
    if availability == 'open'
      AVAILABILITIES
    elsif AVAILABILITIES[0..2].include? availability
      AVAILABILITIES[0..2] << 'open'
    elsif availability == 'weekends'
      AVAILABILITIES.slice(3..3) << 'open'
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
    role == 'student' ? 'mentor' : 'student'
  end
end
