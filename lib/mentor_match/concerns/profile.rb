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
  end
end
