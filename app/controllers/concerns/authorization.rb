module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    # Check that `authorize` has been called in every controller action (not a failsafe!)
    after_action :verify_authorized

    def pundit_user
      # We have to call `authenticated?` such that Current.user is available
      Current.user if authenticated?
    end
  end

  class_methods do
    def allow_unauthorized_access(**options)
      skip_after_action :verify_authorized, **options
    end
  end
end
