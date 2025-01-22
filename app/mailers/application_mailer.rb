class ApplicationMailer < ActionMailer::Base
  include Mailers::User
  include Mailers::Localization

  default from: email_address_with_name("noreply@terraforming-cologne.de", "Terraforming Cologne")
  layout "mailer"
end
