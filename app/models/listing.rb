class Listing < ActiveRecord::Base

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_create :set_user_to_host
  after_destroy :clear_user_host_status

  def average_review_rating
    self.reviews.map { |review| review.rating.to_f }.sum / (self.reviews.length)
  end

  private

  def find_user
    @user = User.find(self.host_id)
  end

  def set_user_to_host
    find_user.host = true
    @user.save
  end

  def clear_user_host_status
    find_user
    if @user.listings.empty?
      @user.host = false
      @user.save
    end
  end
#Listing.all[2].reviews[0].rating
end
