require 'rack'
require 'rack/session/redis'
require 'redis-store'
use Rack::Session::Redis, redis_server: ENV['REDISCLOUD_URL']
