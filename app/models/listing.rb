class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  before_save :change_host_status
  after_destroy :change_host_status_to_false

  def change_host_status
    user = self.host
    user.host = true
    user.save
  end

  def available_listings(start_date, end_date)
     
  end

  def change_host_status_to_false
    user = self.host
    if user.listings == []
      user.host = false
      user.save
    end
  end

  def average_review_rating
    self.reviews.average(:rating).to_f
  end


end
