require 'octokit'
require 'sinatra'
require 'mentor_match/concerns'
require 'rack/protection'

module MentorMatch
  class Application < Sinatra::Base
    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include HealthCheck
    include Authentication

    configure do
      set :haml, format: :html5

      enable :sessions
      enable :show_exceptions

      enable :logging
      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync
      use Rack::CommonLogger, file
    end

    get '/' do
      if authenticated?
        client = Octokit::Client.new(access_token: current_user.token)
        @user = client.user
        @repositories = client.user.rels[:repos].get.data
      end

      haml :index
    end
  end
end
