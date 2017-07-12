class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address
  validates_presence_of :listing_type
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :price
  validates_presence_of :neighborhood_id

  before_create :is_host
  after_destroy :no_listings_no_host

  def average_review_rating
    ratings = self.reservations.all.map do |reservation|
      reservation.review.rating
    end
    ratings.inject(0.0){|sum,x| sum + x}/ratings.size
  end

  private

  def no_listings_no_host
    user = User.find(self.host_id)
    user.update(host: false) if user.listings.empty?
  end

  def is_host
    User.find(self.host_id).update(host: true)
  end
end
