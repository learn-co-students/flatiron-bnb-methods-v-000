class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_before_checkout #, presence: true
  validate :not_host
  validate :available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price.to_i * self.duration
  end


  def not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own listing.")
    end
  end

  def checkin_before_checkout
    # if checkin_to_i > checkout_to_i
    #   errors.add(:guest_id, 'Invalid checkin date')
    # end
      unless !self.checkin || !self.checkout
         if self.checkin >= self.checkout
           errors.add(:guest_id, 'Invalid checkin date')
         end
       end
  end

  def available
    self.listing.reservations.each do |reservation|
      # date1 = checkin
      # date2 = checkout
      dates = reservation.checkin..reservation.checkout
      if dates === self.checkin || dates === self.checkout
      # if reservation.guest_id == nil
        errors.add(:guest_id, 'Not available for these dates.')
      end
    end
  end


end
