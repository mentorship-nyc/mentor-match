require 'faraday_middleware'
require 'octokit'

module MentorMatch
  module OAuthProviders
    GITHUB_URL            = 'https://github.com'
    GITHUB_OAUTH_CALLBACK = "#{ENV['DOMAIN']}/auth/github/callback"
    GITHUB_AUTHORIZE_URL  = "#{GITHUB_URL}/login/oauth/authorize"
    GITHUB_TOKEN_URL      = '/login/oauth/access_token'

    SLACK_URL             = 'https://github.com'
    SLACK_OAUTH_CALLBACK  = "#{ENV['DOMAIN']}/auth/slack/callback"
    SLACK_AUTHORIZE_URL   = "#{SLACK_URL}/login/oauth/authorize"
    SLACK_TOKEN_URL       = '/api/oauth.access'

    def self.included(base)
      base.get '/auth/github' do
        segments = {}
        segments['client_id'] = ENV['GITHUB_KEY']
        segments['redirect_uri'] = GITHUB_OAUTH_CALLBACK
        segments['scope'] = 'user:email,public_repo,gist,read:public_key'
        segments['state'] = session['auth.state'] = SecureRandom.base64(32)
        query = segments.map{ |k,v| "#{k}=#{v}" }.join('&')

        redirect to("#{GITHUB_AUTHORIZE_URL}?#{query}")
      end

      base.get '/auth/github/callback' do
        if params[:state].gsub(' ', '+') == session['auth.state']
          response = connection(GITHUB_URL).get do |request|
            request.url GITHUB_TOKEN_URL
            request.headers['Accept']       = 'application/json'
            request.params['client_id']     = ENV['GITHUB_KEY']
            request.params['client_secret'] = ENV['GITHUB_SECRET']
            request.params['code']          = params[:code]
            request.params['redirect_uri']  = GITHUB_OAUTH_CALLBACK
          end

          session['auth.github.token'] = response.body['access_token']
          client = Octokit::Client.new(access_token: response.body['access_token'])

          user = User.find_with_oauth({
            'provider' => :github, 'uid' => client.user.id,
            credentials: {
              token: response.body['access_token']
            },
            info: {
              email: client.user.email,
              name: client.user.name,
              image: client.user.avatar_url,
              location: client.user.location
            }
          }, current_user)

          session['auth.entity_id'] = user.id
        else
          halt 403, 'state not authentic'
        end
      end

      base.get '/auth/slack' do
        segments = {}
        segments['client_id'] = ENV['SLACK_CLIENT_ID']
        segments['redirect_uri'] = SLACK_OAUTH_CALLBACK
        segments['scope'] = 'read,post'
        segments['state'] = session['auth.state'] = SecureRandom.base64(32)
        segments['team'] = ENV['SLACK_TEAM']
        query = segments.map{ |k,v| "#{k}=#{v}" }.join('&')

        redirect to("#{SLACK_AUTHORIZE_URL}?#{query}")
      end

      base.get '/auth/slack/callback' do
        if params[:state].gsub(' ', '+') == session['auth.state']
          response = connection(SLACK_URL).get do |request|
            request.url SLACK_TOKEN_URL
            request.params['client_id']     = ENV['SLACK_CLIENT_ID']
            request.params['client_secret'] = ENV['SLACK_CLIENT_SECRET']
            request.params['code']          = params[:code]
            request.params['redirect_uri']  = SLACK_OAUTH_CALLBACK
          end

          session['auth.slack.token'] = response.body['access_token']
        else
          halt 403, 'state not authentic'
        end
      end
    end

    def current_user
      session['auth.entity_id'] && User.where(session['auth.entity_id']).first
    end

    def connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.response :json, :content_type => /\json$/
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
