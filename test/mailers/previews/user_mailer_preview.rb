class UserMailerPreview < ApplicationMailerPreview
  def confirmation
    UserMailer.with(user: @user).confirmation
  end

  def paid
    UserMailer.with(user: @user).paid
  end
end
