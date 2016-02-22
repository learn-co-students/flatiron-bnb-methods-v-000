require 'pry'
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  validate :check_for_neighborhood

  before_save :make_user_into_host
  before_destroy :change_host_status

  def average_review_rating
    rating_sum = 0
    total_reviews = self.reviews.count

    self.reviews.each do |review|
      rating_sum += review.rating
    end
    rating_sum.to_f/total_reviews
  end

  private
    def make_user_into_host
      if !self.host.host
        self.host.update(host: true)
      end
    end

    def change_host_status
      if self.host.listings.count == 1
        self.host.update(host: false)
      end
    end

    def check_for_neighborhood
      if !Neighborhood.exists?(neighborhood_id)
        errors.add(:neighborhood_id, "does not exist.")
      end
    end
end
