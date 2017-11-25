class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :same_person
  validate :checking_in
  validate :checking_in_before_checkingout
  validate :is_available

  def duration
  	checkout - checkin
  end

  def total_price
  	listing.price * duration
  end


  private

  def same_person
  	if guest_id == listing.host_id
  		errors.add(:reservation, "You can't book your very own listing.")
  	end
  end

  def checking_in
  	if checkin == checkout
  		errors.add(:reservation, "Please check your dates again")
  	end
  end

  def checking_in_before_checkingout
  	if checkout && checkin && checkout < checkin
  		errors.add(:reservation, "Please check your dates again")
  	end
  end

  def is_available
  	if checkout && checkin
  		listing.reservations.each do |reserve|
  			if reserve.checkin <= checkout && reserve.checkout >= checkin
  				errors.add(:reservation, "Please check your dates again")
  			end
  		end
  	end
  end

end
