class StaticPagesController < ApplicationController
  allow_unauthenticated_access

  def index
    @tournament = Tournament.next
  end
end
