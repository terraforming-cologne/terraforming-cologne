class Password
  include ActiveModel::Model

  attr_accessor :user, :password, :password_confirmation

  def update(password)
    if user.update(password: password[:password], password_confirmation: password[:password_confirmation])
      true
    else
      user.errors.each do |error|
        errors.add(error.attribute, error.type, **error.options)
      end
      false
    end
  end

  def persisted?
    true
  end
end
