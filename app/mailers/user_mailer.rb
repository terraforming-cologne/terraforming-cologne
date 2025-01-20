class UserMailer < ApplicationMailer
  def confirmation
    mail to: @user.email_address
  end

  def paid
    mail to: @user.email_address
  end
end
