module MentorMatch
  module Challenges
    def self.included(base)
      base.before '/challenges' do
        authenticate!
      end

      base.get '/challenges' do
        @challenges = Challenge.limit(20)
        haml :challenges, layout: DEFAULT_LAYOUT
      end

      base.get '/challenges/:id/:name' do
        @challenge = Challenge.where(id: params[:id]).first
        haml :challenge, layout: DEFAULT_LAYOUT
      end
    end
  end
end
