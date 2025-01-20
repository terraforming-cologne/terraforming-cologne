module Localization
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale

    def switch_locale(&action)
      locale = cookies[:locale]
      locale = locale.to_s.to_sym if I18n.available_locales.map(&:to_sym).include?(locale.to_s.to_sym)
      locale ||= I18n.default_locale

      I18n.with_locale(locale, &action)
    end
  end
end
