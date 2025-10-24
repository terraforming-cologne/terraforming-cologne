class LoginsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  allow_unauthorized_access only: [:destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to :login }

  def new
    redirect_to :root and return if authenticated?

    @login = Login.new
  end

  def create
    @login = Login.new(login_params)
    if @login.save
      start_new_session_for @login.user
      redirect_to after_authentication_path, notice: t(".notice", name: @login.user.name)
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    terminate_session
    redirect_to :root, notice: t(".notice")
  end

  private

  def login_params
    params.expect(login: [:email_address, :password])
  end
end
