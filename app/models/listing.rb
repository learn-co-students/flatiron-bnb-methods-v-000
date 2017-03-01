class Listing < ActiveRecord::Base

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

validates_presence_of :title, :description, :address, :listing_type, :price, :neighborhood

before_create :user_to_host
after_destroy :remove_host_status

  def average_review_rating
    ratings = self.reviews.collect {|review| review.rating}
    ratings.reduce(:+).to_f / ratings.count
  end

  def dates_occupied
    dates = self.reservations.collect do |res|
      res.all_res_dates
    end
    dates.flatten!
  end

private

  def user_to_host
    self.host.update(host: true)
  end

  def remove_host_status
    if self.host.listings.count == 0
      self.host.update(host: false)
    end
  end

end
