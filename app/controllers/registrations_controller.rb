class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  def new
    redirect_to new_participant_path and return if authenticated?

    @user = User.new
    session[:return_to_after_authenticating] = new_participant_path
  end
end
