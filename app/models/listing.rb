class Listing < ActiveRecord::Base
  # Associations
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :neighborhood_id, presence: true

  #callbacks
  before_save :update_status_to_host
  before_destroy :user_not_host


  private

  def update_status_to_host
    user = self.host
    user.update(host: true)
    user.save
  end

  def user_not_host
    user = self.host
    if user.listings.count == 1
      user.update(host: false)
    end

    def average_review_rating
      total_ratings = 0
      self.reviews.each do |review|
        total_ratings += review.rating 
      end
      total_ratings/self.reviews.count.to_f
  
    end
  end


end



 