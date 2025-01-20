class PasswordsMailerPreview < ApplicationMailerPreview
  def reset
    PasswordsMailer.with(user: @user).reset
  end
end
