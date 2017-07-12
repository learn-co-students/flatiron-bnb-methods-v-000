require 'pry'

class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :through => :reservations, :class_name => "User"
  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  before_destroy :change_host_to_false_when_listings_deleted
  before_create :change_user_to_host

    def change_user_to_host
        self.host.host = true
        self.host.save
    end

    def change_host_to_false_when_listings_deleted
      if self.host.listings.length == 1
        self.host.host = false
        self.host.save
      end
    end

    def average_review_rating
        total = 0
        review_count = 0
        self.reviews.each do |review|
            total += review.rating
            review_count += 1
        end
        (total.to_f / review_count).round(2)

    end

end
