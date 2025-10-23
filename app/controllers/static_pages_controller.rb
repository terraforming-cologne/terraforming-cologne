class StaticPagesController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  def index
    @tournament = Tournament.next
  end
end
