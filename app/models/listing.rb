class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_create :change_host_status
  after_destroy :still_host?

  def average_review_rating
    self.reviews.average("rating").to_f
  end


  def change_host_status
    User.find(host_id).update(host: true)
  end

  def still_host?
    u=User.find(host_id)
    u.update(host: false) if u.listings.empty?
  end

  def available(start, fin)
    dates=(start..fin)
    self.reservations.none?{|r| dates.overlaps?(r.checkin..r.checkout)}
  end

end

