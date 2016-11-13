class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  after_create :change_host_status
  after_destroy :change_host_status

  def change_host_status
    user = self.host
    if user.listings.count == 0
      user.host = false
      user.save
    else
      user.host = true
      user.save
    end
  end

  def average_review_rating
    if self.reviews.count == 0
      nil
    else
      ratings_sum = 0
      self.reviews.each do |review|
        ratings_sum += review.rating
      end
      ratings_avg = ratings_sum.to_f / self.reviews.count
    end
  end

end
