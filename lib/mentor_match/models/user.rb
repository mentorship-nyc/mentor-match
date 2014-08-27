class User < ActiveRecord::Base

  before_create {|model| model.confirmation_token = SecureRandom.hex(25)}
  after_create  {|model| model.send_confirmation!}

  has_many :identities
  has_one  :profile

  def self.find_with_oauth(hash, signed_in_user = nil)
    identity = Identity.create_with_oauth(hash)

    if signed_in_user
      identity.user = signed_in_user
    else
      identity.user = where(email: identity.email).first_or_initialize
    end

    identity.decorate_user
    identity.save
    identity.user
  end

  def confirm!
    #UserMailer.signup_summary(self).deliver
    update_attributes(confirmation_token: nil, confirmed_at: DateTime.now)
  end

  def confirmed?
    !!confirmed_at
  end

  def github
    @github ||= identities.github
  end

  def profile_from_identity
    build_profile(name: github.full_name, image: github.image, location: github.location)
  end

  def send_confirmation!
    #UserMailer.confirmation_instructions(self).deliver
    update_attributes(confirmation_sent_at: DateTime.now)
  end
end
