require 'rack-timeout'

use Rack::Timeout
Rack::Timeout.timeout = 10
