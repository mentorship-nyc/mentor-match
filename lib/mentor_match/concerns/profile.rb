module MentorMatch
  module Profile
    def self.included(base)
      base.before '/profile' do
        authenticate!
      end

      base.get '/profile' do
        haml :profile, layout: DEFAULT_LAYOUT
      end
    end

    def authenticate!
      unless authenticated?
        redirect to("/auth/github?redirect_uri=#{request.path}")
      end
    end

    def self.authenticated?
      !!session['auth.entity_id']
    end
  end
end
