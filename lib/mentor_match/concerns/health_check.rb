module MentorMatch
  module HealthCheck
    def self.included(base)
      base.get '/ping' do
        'pong'
      end
    end
  end
end
