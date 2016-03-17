class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  before_save :activate_host
  after_destroy :deactivate_host


  def average_review_rating
    ratings_sum = self.reviews.inject(0){|sum, r| sum+= r.rating}.to_f
    ratings_count = self.reviews.count.to_f
    ratings_average = ratings_sum / ratings_count
    ratings_average
  end


private

  def activate_host
    host.host = true
    host.save
  end

  def deactivate_host
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

  
end
