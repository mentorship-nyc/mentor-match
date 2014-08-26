class Profile < ActiveRecord::Base

  AVAILABILITIES = [
    'weekly', 'bi-weekly', 'weekends', 'week-nights', 'open'
  ]

  after_create do |model|
    MentorMatch::Slack.advertise_profile(model)
    MentorMatch::UserMailer.signup(model.user.name, model.user.email, model.role)
  end

  validates :bio,          length: {maximum: 500}, allow_blank: false
  validates :availability, inclusion: {in: AVAILABILITIES}
  validates :skills,       length: {maximum: 255, minimum: 5}, allow_blank: false

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
