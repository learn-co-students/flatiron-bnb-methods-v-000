require 'pry'
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_save :change_host_status_to_true

  after_destroy :change_host_status_to_false

  def available?(start_date, end_date)
    self.reservations.none? do |reservation|
      booked = reservation.checkin .. reservation.checkout
      booked === start_date || booked === end_date
    end
  end

  def change_host_status_to_true
    current_host.update(host: true)
  end

  def change_host_status_to_false

    current_host.update(host: false) if current_host.listings == []
  end

  def current_host
    self.host
  end

  def average_review_rating
    total_reviews = self.reviews.count
    total_rating = self.reviews.inject(0) {|sum, review| sum + review.rating}
    total_rating.to_f / total_reviews.to_f
  end
end
