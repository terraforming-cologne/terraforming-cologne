class PasswordsController < ApplicationController
  allow_unauthorized_access

  before_action :set_user, only: [:edit, :update]
  before_action :set_password, only: [:edit, :update]

  def edit
  end

  def update
    if @password.update(password_params)
      redirect_to :profile, notice: t(".notice")
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def set_password
    @password = Password.new(user: @user)
  end

  def password_params
    params.expect(password: [:password, :password_confirmation])
  end
end
