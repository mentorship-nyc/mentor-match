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

  def matches
    Profile.includes(:user).
      where(availability: availability).
      where(availability: 'open').
      where.not(id: id).
      limit(20)
  end

  def name
    user.name
  end

  def nickname
    user.github.nickname
  end
end
