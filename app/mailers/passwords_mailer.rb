class PasswordsMailer < ApplicationMailer
  def reset
    mail to: @user.email_address
  end
end
