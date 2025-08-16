class OrgaMailer < ApplicationMailer
  def cancellation(user, participation)
    @user = user
    @participation = participation
    mail to: email_address_with_name("orga@terraforming-cologne.de", "Orga")
  end
end
