module SpamProtection
  extend ActiveSupport::Concern

  class_methods do
    def spam_protect(**options)
      rate_limit to: 2, within: 5.minutes, with: -> { redirect_to :root, alert: t(:try_again_later) }, **options
    end
  end
end
