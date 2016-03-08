class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  #validates :address, presence: true
  #validates :listing_type, presence: true
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_save :set_host
  after_destroy :set_user

  def average_review_rating
    review_ratings = []
      self.reservations.each do |reservation|
        review_ratings << reservation.review.rating
      end
      review_ratings.sum.to_f / review_ratings.count
    end


  private 

    def set_host 
      self.host.update(host: true)
    end

    def set_user
      if self.host.listings.empty?
        self.host.update(host: false)
      end
    end
end
