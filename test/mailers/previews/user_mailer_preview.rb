class UserMailerPreview < ActionMailer::Preview
  def confirmation
    UserMailer.confirmation(User.take)
  end

  def paid
    UserMailer.paid(User.take)
  end
end
