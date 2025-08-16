class OrgaMailerPreview < ApplicationMailerPreview
  def cancellation
    OrgaMailer.cancellation(User.take, Participation.take)
  end
end
