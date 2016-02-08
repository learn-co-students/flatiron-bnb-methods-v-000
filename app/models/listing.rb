class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: :true
  before_save :set_host
  after_destroy :set_user


  def average_review_rating
    ratings = []
    self.reviews.each do |review|
      ratings << review.rating
    end  
    average = ratings.sum / ratings.size.to_f
  end  

  private

    def set_host
      self.host.update(host: true)
    end  

    def set_user
      if self.host.listings.count == 0
        self.host.update(host: false)
      end  
    end  
end
