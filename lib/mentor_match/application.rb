require 'haml'
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
      haml :index
    end

    post '/signup' do
      UserMailer.signup(params[:name], params[:email], params[:role])
      Slack.signup(params[:name], params[:email], params[:role])

      redirect to('/')
    end

    get '/*' do
      static!(params[:splat].first)
    end
  end
end
