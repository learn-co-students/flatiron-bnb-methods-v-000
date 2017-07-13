class Listing < ActiveRecord::Base
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create do
    self.host.update(host: true)
  end

  after_destroy do
    if host.listings.length == 0
      self.host.update(host: false)
    end
  end

  def average_review_rating
    sum = 0.0
    count = 0

    self.reviews.each do |review|
      sum += review.rating
      count += 1
    end

    sum / count
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_city = nil

    self.all.each do |city|
      reservations = 0
      curr_ratio = 0.0
      listing_num = city.listings.length

      city.listings.each do |listing|
        reservations += listing.reservations.length
      end

      curr_ratio = reservations / listing_num unless listing_num == 0 || reservations == 0

      if curr_ratio > highest_ratio
        highest_ratio = curr_ratio
        highest_city = city
      end
    end
    highest_city
  end

  def self.most_res
    most_res = 0
    most_city = nil

    self.all.each do |city|
      reservations = 0

      city.listings.each do |listing|
        reservations += listing.reservations.length
      end

      if reservations > most_res
        most_res = reservations
        most_city = city
      end
    end
    most_city
  end
end
