module Mailers::Localization
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale

    def switch_locale(&action)
      I18n.with_locale(@user.locale, &action)
    end
  end
end
