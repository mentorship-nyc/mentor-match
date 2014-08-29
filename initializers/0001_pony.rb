options = {
  from: 'The Mentoring NYC Team <team@mentoring-nyc.com>',
  via: :smtp,
  via_options: {
    address: ENV['SMTP_ADDRESS'],
    port: ENV['SMTP_PORT'],
    authentication: ENV['SMTP_AUTHENTICATION'] || :plain,
    domain: ENV['SMTP_DOMAIN']
  }
}

options[:via_options][:user_name] = ENV['MANDRILL_USERNAME'] if ENV['MANDRILL_USERNAME']
options[:via_options][:password] = ENV['MANDRILL_APIKEY']    if ENV['MANDRILL_USERNAME']

Pony.options = options
