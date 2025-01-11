class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.expect(registration: [user_attributes: [:name, :email_address, :password, :password_confirmation], participant_attributes: [:brings_basegame, :brings_prelude, :brings_hellas_and_elysium]])
  end
end
