class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  # Listing is only valid if it has an address, listing_type, title,
  # description, price, and neighborhood_id
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  after_create :toggle_host_status
  after_destroy :toggle_host_status



  # Returns true if a listing has an opening within a range of dates.
  def available?(start_date, end_date)
    unless self.reservations.any? { |res| start_date.to_date.between?(res.checkin, res.checkout) || end_date.to_date.between?(res.checkin, res.checkout)} 
      true
    end
  end

  # Averages all of the reviews for a listing
  def average_review_rating
    self.reviews.all.average(:rating)
  end

  private 

  # When a user creates a listing, they become a host, and when they destroy all listings, they are no longer a host.
  def toggle_host_status
    if !self.host.listings.empty?
      self.host.update(host: true)
    else
      self.host.update(host: false)
    end
  end

end
