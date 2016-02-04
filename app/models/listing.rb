class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_save :make_user_host
  before_destroy :user_host?

  def not_available_dates
    not_available_dates = [] 
    self.reservations.each do |reservation|
      start = reservation.checkin
      until start == reservation.checkout 
        not_available_dates << start
        start += 1 
      end
    end
    not_available_dates
  end

  def average_review_rating
    all_ratings = self.reviews.all.map do |review| 
      review.rating
    end
    all_ratings.inject(0, :+).to_f/self.reviews.count
  end

  private
    def make_user_host
      unless self.host == true
        self.host.update(:host => true)
      end
    end

    def user_host?
      if self.host.listings.count <= 1
        self.host.update(:host => false)
      end 
    end

end
