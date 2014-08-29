module AuthenticationHelpers
  def authenticated?
    !!session['auth.entity_id']
  end

  def current_user
    @current_user ||= User.where(id: session['auth.entity_id']).first
  end

  def has_value(user, attribute, value)
    user.send(attribute) == value
  end
end

MentorMatch::Application.helpers AuthenticationHelpers
