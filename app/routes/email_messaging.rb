require 'json'
require 'pony'

module MentorMatch
  module EmailMessaging
    def self.included(base)
      base.post '/messaging/email/team' do
        events = JSON.parse(params['mandrill_events'])
        event = events[0]

        $stdout.puts event

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

      base.post '/messaging/email/slack' do
        events = JSON.parse(params['mandrill_events'])
        event = events[0]

        $stdout.puts event

        if event && event['event'] == 'inbound'
          message = event['msg']

          text = <<-TEXT
            *ACCESS REQUEST*: #{message['from_email']} -> #{message['subject']}\n\n#{message['text']}
          TEXT

          Slack.message('#invites', 'slackbox', text)
        end
      end
    end
  end
end
