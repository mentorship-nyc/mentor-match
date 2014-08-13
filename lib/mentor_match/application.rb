require 'haml'
require 'json'
require 'securerandom'
require 'sinatra'
require 'mentor_match/user_mailer'
require 'mentor_match/slack'
require 'mentor_match/concerns'

module MentorMatch
  class Application < Sinatra::Base
    set :root,  "#{File.dirname(__FILE__)}/../../"
    set :views, Proc.new { File.join(root, 'views') }

    include HealthCheck

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
      @csrf = session[:csrf] = SecureRandom.base64(32)
      haml :index
    end

    post '/messaging/email/team' do
      events = JSON.parse(params['mandrill_events'])
      event = events[0]

      if event && event['event'] == 'inbound'
        message = event['msg']

        Pony.mail({
          to: 'chad.pry@gmail.com',
          from: "#{message['from_name']} <#{message['from_email']}>",
          subject: "FWD: #{message['subject']}",
          html_body: message['html']
        })
      end
    end

    post '/messaging/email/slack' do
      events = JSON.parse(params['mandrill_events'])
      event = events[0]

      if event && event['event'] == 'inbound'
        message = event['msg']

        text = <<-TEXT
          *ACCESS REQUEST*: #{message['from_email']} -> #{message['subject']}\n\n#{message['text']}
        TEXT

        Slack.message('#invites', 'slackbox', text)
      end
    end

    post '/signup' do
      when_successful_post do
        UserMailer.signup(params[:name], params[:email], params[:role])
        Slack.signup(params[:name], params[:email], params[:role])

        redirect to('/')
      end
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

    def when_successful_post
      if session[:csrf] == params[:csrf]
        yield
      else
        status 400
      end
    end
  end
end
