require 'dotenv'
require 'rack-timeout'

Dotenv.load

$:.unshift './lib'

require 'mentor_match/application'
require 'initializers'

use Rack::Timeout
Rack::Timeout.timeout = 10

run MentorMatch::Application.run!
