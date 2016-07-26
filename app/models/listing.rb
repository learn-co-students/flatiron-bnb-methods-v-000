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

  before_save :change_user_host_status, on: [:create, :update]
  before_destroy :adjust_user_host_status

  def available?(date)
    self.reservations.each do |reservation|
      if date.to_date.between?(reservation.checkin.to_date, reservation.checkout.to_date)
        return false
      end
    end
    return true
  end

  def num_reviews
    self.reviews.count
  end

  def average_review_rating
    sum_of_ratings = self.reviews.inject(0) {|sum, i| sum + i.rating}
    sum_of_ratings.to_f / num_reviews
  end

  private
  
  def change_user_host_status
    host.set_host_to_true
  end

  def adjust_user_host_status
    if self.host.listings.size == 1
      host.set_host_to_false
    end
  end

end
