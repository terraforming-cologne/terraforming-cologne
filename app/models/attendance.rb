class Attendance < ApplicationRecord
  include Ranking

  belongs_to :participation
end
