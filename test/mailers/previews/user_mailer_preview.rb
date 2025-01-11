class UserMailerPreview < ActionMailer::Preview
  def welcome
    UserMailer.welcome(User.take)
  end

  def paid
    UserMailer.paid(User.take)
  end
end
