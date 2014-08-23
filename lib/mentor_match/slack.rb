require 'faraday_middleware'

module MentorMatch
  class Slack
    SLACK_HTTPS_URL = 'https://slack.com'

    def self.signup(name, email, role)
      message '#signups', 'slackbot', <<-TEXT
        *Heads up everyone!* #{name} -> #{email} just signed up on www.mentoring-nyc.com to be a #{role}.
        If anyone is a available and wants to collaborate, send him/her an email.
      TEXT
    end

    def self.advertise_profile(model)
      message '#signups', 'slackbot', <<-TEXT
        *Heads up everyone!* #{model.user.name} -> #{model.user.email} just signed up on www.mentoring-nyc.com to be a #{model.role}.
        If anyone is a available and wants to collaborate, send him/her an email.
      TEXT
    end

    def self.message(channel, username, text)
      connection.post '/api/chat.postMessage', {
        token: ENV['SLACK_TOKEN'], channel: channel,
        username: username, text: text
      }
    end

    def self.opposite(role)
      role == 'mentor' ? 'student' : 'mentor'
    end

    def self.connection
      @connection = Faraday.new(url: SLACK_HTTPS_URL) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
