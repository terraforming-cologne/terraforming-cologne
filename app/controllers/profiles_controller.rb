class ProfilesController < ApplicationController
  allow_unauthorized_access

  before_action :set_user, only: [:show, :edit]

  def show
  end

  def edit
  end

  private

  def set_user
    @user = Current.user
  end
end
