class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  before_create :make_user_a_host
  after_destroy :make_user_non_host

  def listing_reserved?(begin_date, end_date)
    self.reservations.any? do |res|
      (begin_date.to_date - res.checkout_date.to_date) * (res.checkin_date.to_date - end_date.to_date) >= 0
      #reservation.checkin_date.between?(begin_date, end_date) || #reservation.checkout_date.between?(begin_date, end_date)
    end
  end

  def make_user_a_host
    self.host.host = true
    self.host.save
  end

  def make_user_non_host
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    self.reviews.average("rating")
  end

  def num_of_reservations(location)
  location.listings.inject(0) do |sum, listing|
      sum + listing.reservations.size
    end
  end

end
