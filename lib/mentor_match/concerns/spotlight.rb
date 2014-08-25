module MentorMatch
  module Spotlight
    def self.included(base)
      base.before '/spotlight' do
        authenticate!
      end

      base.get '/spotlight' do
        @profiles = current_profile.matches
        haml :'spotlight/index', layout: DEFAULT_LAYOUT
      end
    end
  end
end
