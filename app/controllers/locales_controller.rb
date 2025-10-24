class LocalesController < ApplicationController
  allow_unauthenticated_access

  def update
    locale = params.expect(:locale)
    locale = I18n.available_locales.include?(locale.to_sym) ? locale : I18n.default_locale
    cookies[:locale] = locale

    redirect_back_or_to :root
  end
end
