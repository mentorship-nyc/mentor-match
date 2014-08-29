require 'pony'

options = {
  from: 'The Mentoring NYC Team <team@mentoring-nyc.com>',
  via: :smtp,
  via_options: {
    address: 'localhost', port: 1025,
    authentication: :plain, domain: 'localhost.localdomain'
  }
}

if ENV['RACK_ENV'] == 'production'
  options[:via_options] = {
    address: 'smtp.mandrillapp.com',
    port: '587',
    user_name: ENV['MANDRILL_USERNAME'],
    password: ENV['MANDRILL_APIKEY'],
    authentication: :plain,
    domain: 'mentoring-nyc.com'
  }
end

Pony.options = options
