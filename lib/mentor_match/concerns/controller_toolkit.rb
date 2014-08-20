module MentorMatch
  module ControllerToolkit
    def authenticate!
      unless authenticated?
        redirect to("/auth/github?redirect_uri=#{request.path}")
      end
    end

    def authenticated?
      !!session['auth.entity_id']
    end

    def connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.response :json, :content_type => /\json$/
        faraday.adapter  Faraday.default_adapter
      end
    end

    def current_user
      authenticated? && User.where(id: session['auth.entity_id']).first
    end

    def flash_transform(type)
      if type == :notice
        'alert-info'
      elsif type == :success
        'alert-success'
      elsif type == :error
        'alert-danger'
      end
    end

    def show(view, options = {})
      haml view, {layout: DEFAULT_LAYOUT}.merge(options)
    end
  end
end
