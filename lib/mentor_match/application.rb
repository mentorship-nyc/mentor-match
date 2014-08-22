require 'haml'
require 'rdiscount'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'mentor_match/user_mailer'
require 'mentor_match/slack'
require 'mentor_match/concerns'

module MentorMatch
  class Application < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    register Sinatra::Flash

    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include ControllerToolkit
    include EmailMessaging
    include Csrf
    include OAuthProviders
    include Profile
    include Challenges

    helpers do
      def authenticated?
        !!session['auth.entity_id']
      end

      def current_user
        @current_user ||= User.where(id: session['auth.entity_id']).first
      end

      def has_value(user, attribute, value)
        user.send(attribute) == value
      end
    end

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
