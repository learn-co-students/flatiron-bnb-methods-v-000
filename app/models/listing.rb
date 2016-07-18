class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_save :change_user_to_host
  before_destroy :change_host_to_user

  def average_review_rating
    @total_ratings = 0.0
    @number_of_reviews = 0

    reviews.each do |review|
      @total_ratings += review.rating
      @number_of_reviews += 1 
    end
    (@total_ratings / @number_of_reviews)
  end


  private

  def change_user_to_host
    user = self.host
    user.update(host: true)
    user.save
  end

  def change_host_to_user
    user = self.host
    if user.listings.count == 1
      user.update(host: false)
      user.save
    end
  end
  
end
