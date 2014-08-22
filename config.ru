$:.unshift './lib'

require 'rack'
require 'rack/health'
require 'rack/protection'
require 'rack/session/redis'
require 'redis-store'
require 'rack-timeout'

require 'file_loader'
require 'mentor_match'
require 'mentor_match/application'
require 'initializers'


use Rack::Health, routes: ['/ping', '/PING'], response: ['PONG']
use Rack::Session::Redis, redis_server: ENV['REDISCLOUD_URL']
use Rack::Protection
use Rack::Timeout

# Browser -> Puma -> RequestInspector -> Health -> Redis -> Protection -> Timeout -> Sinatra
# Browser <- Puma <- RequestInspector <- Health <- Redis <- Protection <- Timeout <- Sinatra

Rack::Timeout.timeout = 10

run MentorMatch::Application
