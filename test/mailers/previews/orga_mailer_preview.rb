class OrgaMailerPreview < ApplicationMailerPreview
  def cancellation
    OrgaMailer.cancellation(User.take)
  end
end
