class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  before_save :change_user_host_status

  def average_review_rating
   self.reviews.average(:rating)
  end

  private

  def change_user_host_status
    user = User.find(self.host_id)
    user.update(host: true)
  end

  def user_host_to_false
   self.host.update(host: false) if self.host.listings.count == 1
  end

end
