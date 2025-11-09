class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  include Localization
  include SpamProtection

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  # TODO: Locale need's to be set here again...
  def user_not_authorized
    locale = cookies[:locale]
    locale = locale.to_s.to_sym if I18n.available_locales.map(&:to_sym).include?(locale.to_s.to_sym)
    locale ||= I18n.default_locale

    I18n.with_locale(locale) do
      redirect_to :root, alert: t(:unauthorized)
    end
  end
end
