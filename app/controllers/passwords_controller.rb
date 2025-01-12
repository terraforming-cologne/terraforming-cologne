class PasswordsController < ApplicationController
  allow_unauthorized_access

  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(password_params)
      redirect_to :profile
    else
      render :edit, status: :processable_entities
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
