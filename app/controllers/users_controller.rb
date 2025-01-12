class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  allow_unauthorized_access only: [:new, :create]

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    authorize @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(params.expect(user: [:email_address]))
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.deactivate!
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end

  def user_params
    params.expect(user: [:name, :email_address, :password, :password_confirmation])
  end
end
