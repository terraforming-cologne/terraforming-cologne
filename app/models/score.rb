class Score < ApplicationRecord
  belongs_to :seat

  validate :ranking_order_stuff

  def ranking_order_stuff
    debugger
    # return false
    true
  end
end
