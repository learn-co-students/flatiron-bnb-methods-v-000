class Listing < ActiveRecord::Base
  # Associations
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  # Validations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  # Callbacks
  before_create :make_user_host
  after_destroy :update_host_status

  # Get the average review rating for a listing
  def average_review_rating
    reviews.average(:rating)
  end

  # Determine is a listing is available in a given checkin date
  def valid_date?(date)
    !self.class.unavilable_listings(date).include?(self)
  end

  # Return unavilable listings given a date
  def self.unavilable_listings(date)
    where_sql = "reservations.checkin <= ? AND reservations.checkout >= ?"
    Listing.joins(:reservations).where(where_sql, date, date)
  end

  private

  def make_user_host
    self.host.update(host: true) unless self.host.host?
  end

  def update_host_status
    self.host.update(host: false) if self.host.listings.size < 1
  end

end
