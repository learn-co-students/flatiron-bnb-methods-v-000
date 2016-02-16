class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :checkin_order
  validate :available?

  validate :host?

  def host?
    if self.listing.host_id == self.guest_id
      errors.add(:base, 'reserving guest cannot be the host')
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price.to_i * duration
  end

  def checkin_order
    return if [self.checkin, self.checkout].any? {|f| f.nil?}
    if self.checkin >= self.checkout
        errors.add(:base, 'checkout must be after checkin')
    end
  end

  def available?
    availibility = true
    return if [self.checkin, self.checkout].any? {|f| f.nil?}    
    start_date = self.checkin
    end_date = self.checkout
      self.listing.reservations.each do |reservation|
        if start_date >= reservation.checkout
        elsif
          if end_date <= reservation.checkin
          end
        else
          availibility = false
        end
      end
    unless availibility
      errors.add(:base, 'date is not available')
    end
  end


end
