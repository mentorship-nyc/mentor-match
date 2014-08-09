require 'faraday'
require 'json'

module MentorMatch
  module Authentication
    GITHUB_URL = 'https://github.com'

    def self.included(base)
      base.get '/login' do
        session['redirect'] = params[:redirect] if params[:redirect]
        redirect to(ENV['GITHUB_AUTH_URL'])
      end

      base.get '/auth/github/callback' do
        response = connection.post do |request|
          request.url '/login/oauth/access_token'
          request.headers['Accept'] = 'application/json'
          request.body = {client_id: ENV["GITHUB_KEY"], client_secret: ENV["GITHUB_SECRET"], code: params["code"]}
        end

        if response.success?
          payload = JSON.parse(response.body)
          client = Octokit::Client.new(access_token: payload['access_token'])

          user = User.with_client(client)

          session['github.token'] = user.token
          session['github.token_type'] = payload['token_type']
        end
        
        redirect to(session['redirect'] || '/')
      end

      base.helpers do
        def current_user
          @current_user ||= User.where(token: session['github.token']).first
        end
      end
    end

    def authenticated?
      !!session['github.token']
    end

    def connection
      Faraday.new(url: GITHUB_URL)  do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    def current_user
      @current_user ||= User.where(token: session['github.token']).first
    end
  end
end
