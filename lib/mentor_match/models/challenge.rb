class Challenge < ActiveRecord::Base

  validates :name,        presence: true, length: {maximum: 100}
  validates :description, presence: true, length: {maximum: 255}
  validates :difficulty,  presence: true, inclusion: {in: %w(light, medium, heavy)}
  validates :problem,     presence: true

end
