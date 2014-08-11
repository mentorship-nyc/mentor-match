require 'pony'

if ENV['RACK_ENV'] == 'production'
  options = {
    from: 'noreply@mentoring-nyc.com',
    via: :smtp,
    via_options: {
      address: 'smtp.mandrillapp.com',
      port: '587',
      user_name: 'app28354064@heroku.com',
      password: 'vn0CxMD-lGCL35Fd1mKwGg',
      authentication: :plain,
      domain: 'mentoring-nyc.com'
    }
  }
else
  options = {
    from: 'noreply@mentoring-nyc.com',
    via: :smtp,
    via_options: {
      address: 'localhost', port: 1025,
      authentication: :plain, domain: 'localhost.localdomain'
    }
  }
end

Pony.options = options
