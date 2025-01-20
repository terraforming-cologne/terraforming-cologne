module Mailers::User
  extend ActiveSupport::Concern

  included do
    before_action :set_user

    def set_user
      @user = params[:user]
    end
  end
end
