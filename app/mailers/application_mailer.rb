class ApplicationMailer < ActionMailer::Base
  include Mailers::User
  include Mailers::Localization

  default from: "noreply@terraforming-cologne.de"
  layout "mailer"
end
