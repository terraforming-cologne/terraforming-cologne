class AccountsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  # NOTE: Authorization is implicit because @user = Current.user
  allow_unauthorized_access

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_path, notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @user.update(params.expect(user: [:name, :email_address, :locale]))
      redirect_to :profile, notice: t(".notice")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.deactivate!
    redirect_to :root, notice: t(".notice")
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    params.expect(user: [:name, :email_address, :password, :password_confirmation, :locale])
  end
end
