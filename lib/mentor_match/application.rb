require 'sinatra'
require 'mentor_match/concerns'
require 'rack/protection'

module MentorMatch
  class Application < Sinatra::Base
    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include HealthCheck

    configure do
      set :haml, format: :html5
      enable :show_exceptions
      enable :logging
      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync
      use Rack::CommonLogger, file
    end

    get '/' do
      haml :index
    end
  end
end
