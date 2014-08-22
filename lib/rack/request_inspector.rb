module Rack
  class RequestInspector
    RACK_SESSION_CONTEXT = 'rack.session'
    SESSION_ID = 'session_id'
    RACK_REQUEST_INSPECTOR_CONTEXT = 'rack.request_inspector'
    REQUEST_ID = 'request_id'
    STARTED = 'started'
    FINISHED = 'finished'

    def initialize(app, options = {})
      @logger = options[:logger] || ::Logger.new(STDOUT)
      @logger.level = options[:level] || ::Logger::INFO
      @app = app
    end

    def call(env)
      started = Time.now.utc

      mark_initial_request(env)
      mark_request_id(env)
      mark_started(env, started)

      status, headers, response = @app.call(env)

      mark_finished(env)

      print(env)

      [status, headers, response]
    end

    def mark_finished(env)
      env[RACK_REQUEST_INSPECTOR_CONTEXT][FINISHED] = Time.now.utc
    end

    def mark_initial_request(env)
      env[RACK_REQUEST_INSPECTOR_CONTEXT] = {}
    end

    def mark_request_id(env)
      env[RACK_REQUEST_INSPECTOR_CONTEXT][REQUEST_ID] = SecureRandom.uuid
    end

    def mark_started(env, started)
      env[RACK_REQUEST_INSPECTOR_CONTEXT][STARTED] = started
    end

    def print(env)
      inspector_context = env[RACK_REQUEST_INSPECTOR_CONTEXT]

      if env[RACK_SESSION_CONTEXT]
        @logger.info "SessionID: #{env[RACK_SESSION_CONTEXT][SESSION_ID]}"
      end

      if env[RACK_REQUEST_INSPECTOR_CONTEXT]
        @logger.info "RequestID: #{inspector_context[REQUEST_ID]}"
      end

      @logger.info "Started: #{inspector_context[STARTED]}"
      @logger.info "Finished: #{inspector_context[FINISHED]}"
      @logger.info "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']} #{env['HTTP_VERSION']}"
      @logger.info "#{diff_in_millis(inspector_context[STARTED], inspector_context[FINISHED])}ms"
    end

    def diff_in_millis(started, finished)
      ((finished - started) * 1000).to_i
    end
  end
end
