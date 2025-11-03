class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  include Localization
  include SpamProtection

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern unless Rails.env.development?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to :root, alert: t(:unauthorized)
  end
end
