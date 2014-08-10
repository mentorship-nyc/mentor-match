require 'haml'
require 'sinatra'
require 'mentor_match/concerns'

module MentorMatch
  class Application < Sinatra::Base
    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include HealthCheck

    configure do
      set :haml, format: :html5
      enable :show_exceptions
      enable :logging
    end

    configure :production do
      require 'newrelic_rpm'
    end

    get '/' do
      haml :index
    end

    get '/*' do
      read_static_file(params[:splat].first)
    end

    def read_static_file(name)
      full_path = File.join(settings.root, 'public', name)

      if File.exist?(full_path)
        File.read(full_path)
      else
        status 404
      end
    end
  end
end
