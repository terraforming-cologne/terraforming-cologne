class PasswordsMailer < ApplicationMailer
  include Mailers::User
  include Mailers::Localization

  def reset
    mail to: email_address_with_name(@user.email_address, @user.name)
  end
end
