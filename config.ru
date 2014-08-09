require 'dotenv'

Dotenv.load

$:.unshift './lib'

require 'mentor_match/models'
require 'mentor_match/application'
require 'initializers'

run MentorMatch::Application.run!
