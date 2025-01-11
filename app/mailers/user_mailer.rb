class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail to: @user.email_address
  end

  def paid(user)
    @user = user
    mail to: @user.email_address
  end
end
