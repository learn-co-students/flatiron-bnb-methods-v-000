class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def available?(start_date, end_date)
    start_date1 = Date.parse(start_date)
    end_date1 = Date.parse(end_date)
    self.checkin >= start_date1 && self.checkout <= end_date1
  end

end
