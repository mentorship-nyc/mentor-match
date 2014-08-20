class Profile < ActiveRecord::Base

  AVAILABILITIES = [
    'weekly', 'bi-weekly', 'weekends', 'week-nights', 'other'
  ]

  validates :bio,          length: {maximum: 500}, allow_blank: false
  validates :availability, inclusion: {in: AVAILABILITIES}
  validates :skills,       length: {maximum: 255, minimum: 5}, allow_blank: false

  belongs_to :user

end
