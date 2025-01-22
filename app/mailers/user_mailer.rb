class UserMailer < ApplicationMailer
  def confirmation
    mail to: email_address_with_name(@user.email_address, @user.name)
  end

  def paid
    mail to: email_address_with_name(@user.email_address, @user.name)
  end
end
