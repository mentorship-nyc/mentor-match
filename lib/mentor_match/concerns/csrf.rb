require 'securerandom'

module MentorMatch
  module Csrf
    def incorrect_csrf?
      session[:csrf] != params[:csrf]
    end

    def self.included(base)
      base.before do
        if request.get?
          @csrf = session[:csrf] = SecureRandom.base64(32)
        end
      end

      base.before do
        halt 403, 'csrf not authentic' if request.form_data? && incorrect_csrf?
      end
    end
  end
end
