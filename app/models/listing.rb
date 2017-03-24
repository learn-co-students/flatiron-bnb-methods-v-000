class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address,      presence: true
  validates :listing_type, presence: true
  validates :title,        presence: true
  validates :description,  presence: true
  validates :price,        presence: true
  validates :neighborhood, presence: true

  before_create :set_user_host
  after_destroy :update_user_host

  # returns the average review rating for this Listing.
  def average_review_rating
    Review.average_rating(reviews)
  end

  # returns all the Listings from the supplied collection of Listings that are available for the entire supplied date range.
  def self.find_openings(listings, start_date, end_date)
    listings.reject { |listing| Reservation.has_conflict?(listing.reservations, start_date, end_date) }
  end

  # returns the object in the collection that has the highest reservations per listing average.
  def self.highest_reservation_to_listing_ratio(collection)
    highest_ratio_obj = nil
    highest_ratio = 0.0
    collection.each { |obj|
      listing_count = obj.listings.size
      if listing_count > 0
        reservation_count = obj.listings.inject(0) { |res_count, listing| res_count + listing.reservations.size }
        obj_ratio = reservation_count.to_f / listing_count.to_f
        if obj_ratio > highest_ratio
          highest_ratio = obj_ratio
          highest_ratio_obj = obj
        end
      end
    }
    highest_ratio_obj
  end

  # returns the object in the collection that has the most reservations.
  def self.most_reservations(collection)
    most_reservations_obj = nil
    highest_reservations = 0
    collection.each { |obj|
      reservation_count = obj.listings.inject(0) { |res_count, listing| res_count + listing.reservations.size }
      if reservation_count > highest_reservations
        highest_reservations = reservation_count
        most_reservations_obj = obj
      end
    }
    most_reservations_obj
  end

  private

    def set_user_host
      host.update(host: true) if host.host == false
    end

    # clear user host flag if this was the last listing the user had.
    def update_user_host
      host.update(host: false) if !Listing.exists?(host: host)
    end

end
