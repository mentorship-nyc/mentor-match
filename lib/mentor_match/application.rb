module MentorMatch
  DEFAULT_LAYOUT = :'layouts/application'

  class Application < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    register Sinatra::Flash

    set :root,  "#{File.expand_path(File.dirname(__FILE__))}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include ControllerToolkit
    include EmailMessaging
    include Csrf
    include OAuthProviders
    include Profile
    include Challenges
    include Spotlight

    configure do
      set :haml, format: :html5
      enable :sessions
      set :session_secret, ENV['SESSION_SECRET']
      enable :logging
    end

    configure :development do
      enable :show_exceptions
    end

    configure :production do
      require 'newrelic_rpm'
    end

    get '/' do
      show :index
    end

    get '/signout' do
      session.clear
      redirect to(back)
    end
  end
end
