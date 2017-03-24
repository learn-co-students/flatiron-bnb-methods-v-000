class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # returns whether or not the supplied dates overlap with this reservation.
  def conflict?(start_date, end_date)
    checkin <= Date.parse(end_date) && checkout >= Date.parse(start_date)
  end
end
