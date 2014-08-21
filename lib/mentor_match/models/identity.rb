class Identity < ActiveRecord::Base

  GITHUB = 'github'
  DECORATIONS = {
    github: {
      name: :full_name, email: :email, image: :image, location: :location
    }
  }

  validates :user_id,                  numericality: true, allow_nil: true
  validates :provider, presence: true, length: {maximum: 50}
  validates :uid,      presence: true, length: {maximum: 25}
  validates :token,    presence: true, length: {maximum: 100}

  belongs_to :user

  scope :github, -> { where(provider: GITHUB).first }

  def self.create_with_oauth(hash)
    identity = where(unique_values(hash)).first_or_create

    identity.token =           hash[:credentials][:token]
    identity.nickname =        hash[:info][:nickname]
    identity.email =           hash[:info][:email]
    identity.full_name =       hash[:info][:name]
    identity.image =           hash[:info][:image]
    identity.location =        hash[:info][:location]

    identity.save if identity.changed?
    identity
  end

  def decorate_user
    if user
      (DECORATIONS[provider.to_sym] || {}).each do |setter, getter|
        user.send("#{setter}=", self.send(getter)) unless user.send(setter)
      end

      user.save
    end
  end

  def github?
    provider == GITHUB
  end

  private

  def self.unique_values(hash)
    stringify_values hash.select {|key, value|
      key == 'provider' || key == 'uid'
    }
  end

  def self.stringify_values(input_hash)
    input_hash.inject({}) do |output_hash, (key, value)|
      output_hash[key] = value.to_s
      output_hash
    end
  end
end
