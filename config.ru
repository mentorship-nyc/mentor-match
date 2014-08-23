$:.unshift './lib'

require 'rack'
require 'rack/health'
require 'rack/request_inspector'
require 'rack/protection'
require 'rack/session/redis'
require 'redis-store'
require 'rack-timeout'

require 'file_loader'
require 'mentor_match'
require 'mentor_match/application'
require 'initializers'

# Browser -> Puma -> Health -> Static -> RequestInspector -> Redis -> Protection -> Timeout -> Sinatra
# Browser <- Puma <- Health <- Static <- RequestInspector <- Redis <- Protection <- Timeout <- Sinatra

use Rack::Health, routes: ['/ping', '/PING'], response: ['PONG']
use Rack::Static, root: 'public', urls: ['/favicon.ico', '/js', '/css', '/images']
use Rack::RequestInspector
use Rack::Session::Redis, redis_server: ENV['REDISCLOUD_URL']
use Rack::Protection
use Rack::Protection::AuthenticityToken
use Rack::Timeout

Rack::Timeout.timeout = 10

run MentorMatch::Application
