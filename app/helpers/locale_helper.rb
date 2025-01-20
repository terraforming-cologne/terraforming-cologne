module LocaleHelper
  def locale_emoji(locale)
    case locale.to_s.to_sym
    when :de
      "🇩🇪"
    when :en
      "🇬🇧"
    else
      raise "This should never happen"
    end
  end
end
