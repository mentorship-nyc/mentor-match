require 'sinatra'
require 'rack/protection'

module MentorMatch
  class Application < Sinatra::Base
    GITHUB_URL = 'https://github.com'

    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    configure do
      set :haml, format: :html5
      enable :logging
      enable :sessions
      enable :show_exceptions
    end

    get '/' do
      haml :index
    end

    get '/login' do
      session['redirect_uri'] = params[:redirect] if params[:redirect]
      redirect to(ENV['GITHUB_AUTH_URL'])
    end

    get '/auth/github/callback' do
      response = connection.post '/login/oauth/access_token', {
        client_id: ENV['GITHUB_KEY'],
        client_secret: ENV['GITHUB_SECRET'],
        code: params['code']
      }

      if response.success?
        session['github.token'] = response.body[:access_token]
        session['github.token_type'] = response.body[:token_type]
      end
    end

    get '/ping' do
      'pong'
    end

    def connection
      @connection ||= Faraday.new(url: GITHUB_URL)  do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
