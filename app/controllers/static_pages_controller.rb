class StaticPagesController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  def home
  end
end
