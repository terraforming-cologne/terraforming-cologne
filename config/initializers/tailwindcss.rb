# Disable inclusion of tailwindcss-rails assets
# https://github.com/rails/tailwindcss-rails/issues/301
Rails.application.config.to_prepare do
  Rails.application.config.assets.precompile -= %w[inter-font.css]
  Rails.application.config.assets.paths.reject! { _1.is_a?(String) && _1.include?("gems/tailwindcss-rails") }
end
