class ProfilesController < ApplicationController
  allow_unauthorized_access

  before_action :set_user, only: [:show, :edit]

  def show
    @next_tournament = Tournament.next
    @next_participation = Current.user.participation_at(Tournament.next)
  end

  def edit
  end

  private

  def set_user
    @user = Current.user
  end
end
