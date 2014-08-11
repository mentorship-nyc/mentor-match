module MentorMatch
  class UserMailer
    def self.signup(options)
      Pony.mail(options)
    end
  end
end
