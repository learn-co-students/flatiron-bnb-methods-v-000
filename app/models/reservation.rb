class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def available?(start_date, end_date)
    start_date2 = Date.parse(start_date)
    end_date2 = Date.parse(end_date)
    self.checkin <= end_date2 && self.checkout >= start_date2
  end

end
