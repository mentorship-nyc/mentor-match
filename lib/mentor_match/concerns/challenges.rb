module MentorMatch
  module Challenges
    def self.included(base)
      base.before '/challenges' do
        authenticate!
      end

      base.get '/challenges' do
        @challenges = []
        haml :challenges, layout: DEFAULT_LAYOUT
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
