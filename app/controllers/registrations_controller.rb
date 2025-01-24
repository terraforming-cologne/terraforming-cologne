class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  def new
    redirect_to [:new, :participation] and return if authenticated?

    @user = User.new
    session[:return_to_after_authenticating] = new_participation_path
  end
end
