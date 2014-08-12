require 'erb'
require 'pony'

module MentorMatch
  class UserMailer
    BASE_PATH = "#{File.dirname(__FILE__)}/../.."
    PATH = "user_mailer"

    def self.signup(name, email, role)
      role = "student" unless role == "mentor"

      template = ERB.new(File.read(File.join(BASE_PATH, 'views', PATH, "#{__method__}.erb")))

      if role == "mentor"
        message = <<-EOF
          Your signup, to be a mentor, was received and we are seeking a student
          for you. &nbsp;If you have any questions in the meantime, feel free
          to contact us at
          <a href="mailto:info@mentoring-nyc.com">info@mentoring-nyc.com</a>.
        EOF
      else
        message = <<-EOF
          Your signup, to be a student, was received and we are seeking a mentor
          for you. &nbsp;If you have any questions in the meantime, feel free
          to contact us at
          <a href="mailto:info@mentoring-nyc.com">info@mentoring-nyc.com</a>.
        EOF
      end

      message += <<-EOF
        <br>
        Would you like to join our slack team?  Benefits include meeting more of the
        community and being able to ask questions in realtime chat.  If so, send an
        email to
        <a href="mailto:slack@mentoring-nyc.com">slack@mentoring-nyc.com</a> and
        we will set you up!
      EOF

      Pony.mail({
        to: "#{name} <#{email}>",
        bcc: 'chad.pry@gmail.com',
        subject: "Mentoring NYC #{role.capitalize} Signup",
        attachments: {
          "mentor-stormtrooper.jpg" => File.read(File.join(BASE_PATH, 'public/images/emails/mentor-stormtrooper.jpg'))
        },
        html_body: template.result(binding)
      })
    end
  end
end
