class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
	validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true
	validates :neighborhood_id, presence: true
	
	before_save :change_user_status

  after_destroy :check_user_status

  def change_user_status
    self.host.host = true
    self.host.save
  end

  def check_user_status
    if self.host.listings.count == 0
      self.host.host = false
      self.host.save
    end
  end
	
	def available?(start_date, end_date)
    self.reservations.none? do |r|
			booked_dates = r.checkin .. r.checkout
			booked_dates === start_date || booked_dates === end_date
    end
  end
	
	def average_review_rating
		self.reviews.average(:rating)
	end

end
