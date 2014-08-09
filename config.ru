require 'dotenv'

Dotenv.load

$:.unshift './lib'

require 'file_loader'
require 'mentor_match/application'
require 'initializers'

run MentorMatch::Application.run!
