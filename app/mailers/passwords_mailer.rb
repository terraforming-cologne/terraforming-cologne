class PasswordsMailer < ApplicationMailer
  def reset
    mail to: email_address_with_name(@user.email_address, @user.name)
  end
end
