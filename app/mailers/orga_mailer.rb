class OrgaMailer < ApplicationMailer
  def cancellation(user)
    @user = user
    mail to: email_address_with_name("orga@terraforming-cologne.de", "Orga")
  end
end
