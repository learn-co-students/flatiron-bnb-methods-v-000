class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    # binding.pry
    self.listing.price.to_i * duration
  end
end
