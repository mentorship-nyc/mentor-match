require 'haml'
require 'rdiscount'
require 'sinatra'
require 'sinatra/activerecord'
require 'mentor_match/user_mailer'
require 'mentor_match/slack'
require 'mentor_match/concerns'

module MentorMatch
  class Application < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include HealthCheck
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
    end

    configure do
      set :haml, format: :html5
      enable :sessions
      enable :logging
    end

    configure :development do
      enable :show_exceptions
    end

    configure :production do
      require 'newrelic_rpm'
    end

    get '/' do
      haml :index, layout: DEFAULT_LAYOUT
    end

    post '/signup' do
      UserMailer.signup(params[:name], params[:email], params[:role])
      Slack.signup(params[:name], params[:email], params[:role])

      redirect to('/')
    end

    get '/signout' do
      session.clear
      redirect to(back)
    end

    get '/*' do
      static!(params[:splat].first)
    end
  end
end
