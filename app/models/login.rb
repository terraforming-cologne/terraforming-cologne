class Login
  include ActiveModel::Model

  attr_accessor :email_address, :password, :user

  def save
    self.user = User.active.authenticate_by(email_address: email_address, password: password)
    if user.blank?
      errors.add(:base, :invalid_login)
      return false
    end
    true
  end
end
