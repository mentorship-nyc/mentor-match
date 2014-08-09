module MentorMatch
  class User < ActiveRecord::Base

    def self.with_client(client)
      user = where(github_id: client.user.id).first_or_initialize

      if user.new_record?
        user.username = client.user[:login]
        user.avatar   = client.user[:avatar_url]
        user.hireable = client.user[:hireable]
        user.name     = client.user[:name]
        user.email    = client.user[:email]
        user.company  = client.user[:company]
        user.location = client.user[:location]
      end

      user.token = client.access_token
      user.save
      user
    end
  end
end
