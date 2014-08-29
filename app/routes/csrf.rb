require 'securerandom'

module MentorMatch
  module Csrf
    def self.included(base)
      base.before do
        if request.get? || request.form_data?
          @csrf = session[:csrf] = SecureRandom.base64(32)
          $stdout.puts "authenticity_token: #{@csrf}"
        end
      end
    end
  end
end
