class PasswordResetsController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  before_action :set_user, only: [:edit, :update]
  before_action :set_password, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    if (user = User.active.find_by(email_address: params[:email_address]))
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to :login
  end

  def update
    if @password.update(password_params)
      redirect_to :login
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.active.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to [:new, :password]
  end

  def set_password
    @password = Password.new(user: @user)
  end

  def password_params
    params.expect(password: [:password, :password_confirmation])
  end
end
