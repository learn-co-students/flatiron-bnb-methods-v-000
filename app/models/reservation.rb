class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :is_host

  validate :is_available, :if => "!checkin.nil? && !checkout.nil?"
 
  validate :valid_dates, :if => "!checkin.nil? && !checkout.nil?"
 

  def is_host
    errors.add(:guest_id, "guest cannot be host") unless !User.find(self.guest_id).host?
  end

  def is_available
# binding.pry
    if !listing.available(self.checkin, self.checkout)
      errors.add(:checkin, "not available.")
    end

  end

  def has_dates

  end

  def valid_dates
     if checkin >= checkout
      errors.add(:checkin, "must be at least 1 day before checkout")
    end
  end


end


=begin
# @range=('2014-05-01'..'2014-05-05')

# def overlaps?(start, fin)
#   (self.checkin - Date.parse(fin)) * (Date.parse(start) - self.checkout) >= 0
# end

@endo=(Date.parse('2014-04-28')..Date.parse('2014-05-02'))
@starto=(Date.parse('2014-05-02')..Date.parse('2014-05-10'))
@allo=(Date.parse('2014-04-28')..Date.parse('2014-05-10'))
@allin=(Date.parse('2014-05-02')..Date.parse('2014-05-03'))

test_dates=('2014-05-01', '2014-05-05')
@testr=(Date.parse('2014-05-01')..Date.parse('2014-05-05'))

=end