class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation_id, presence: true
  validates :rating, numericality: true

  before_validation :is_trip_completed

  private
  def is_trip_completed
    (reservation) && (reservation.status == "accepted") && (reservation.checkout < Date.today)
  end

end


## Passes both master and solution branch specs
