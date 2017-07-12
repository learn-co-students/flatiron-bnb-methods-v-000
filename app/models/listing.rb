class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  before_save :user_to_host
  before_destroy :host_to_user

  def user_to_host
    user = User.find(self.host_id)
    user.update(host: true)
  end

  def host_to_user
    user = User.find(self.host_id)
    if user.listings.size == 1
      user.update(host: false)
    end
  end

  def average_review_rating
    ratings = []
    reservations.each {|res| ratings << res.review.rating unless res.review.nil?}
    ratings.sum.to_f/ratings.size
  end

  def available?(checkin, checkout)
    @checkin = checkin
    @checkout = checkout
    reservations.each do |res| 
      if res.checkin <= @checkout.to_date && res.checkout >= @checkin.to_date
          false
      else
          true
      end
    end
  end

  # def booked
  #   @booked = []
  #   self.reservations.each do |reservation| 
  #     @booked = (reservation.checkin..reservation.checkout).map{|date| date}
  #   end
  #   @booked.uniq!
  # end

end

