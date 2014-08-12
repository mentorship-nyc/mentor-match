require 'faraday'

module MentorMatch
  class Slack
    SLACK_HTTPS_URL = 'https://slack.com'

    def self.signup(name, email, role, options = {})
      connection.post '/api/chat.postMessage', {
        token: ENV['SLACK_TOKEN'],
        channel: options[:channel] || '#mentorship',
        username: options[:username] || 'slackbot',
        text: <<-TEXT
          *Heads up everyone!* #{name} -> #{email} is looking to be a #{role}.
          If anyone is a #{opposite(role)} and wants to work together, send him/her an email.
        TEXT
      }
    end

    def self.opposite(role)
      role == 'mentor' ? 'student' : 'mentor'
    end

    def self.connection
      @connection = Faraday.new(url: SLACK_HTTPS_URL) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
