require 'securerandom'

module MentorMatch
  module Csrf
    def incorrect_csrf?
      session[:csrf] != params['csrf']
    end

    def self.included(base)
      base.before do
        halt 403, 'csrf not authentic' if request.form_data? && incorrect_csrf?
      end

      base.before do
        if request.get? || request.form_data?
          @csrf = session[:csrf] = SecureRandom.base64(32)
        end
      end
    end
  end
end
