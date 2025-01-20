class ApplicationMailerPreview < ActionMailer::Preview
  def initialize(*)
    super
    @user = User.take
    @user.locale = params[:locale]
  end
end
