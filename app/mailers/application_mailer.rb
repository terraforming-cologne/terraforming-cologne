class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("noreply@terraforming-cologne.de", "Terraforming Cologne")
  layout "mailer"
end
