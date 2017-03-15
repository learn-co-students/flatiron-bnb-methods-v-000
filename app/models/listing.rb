class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  after_create :change_user_host_status
  after_destroy :change_host_status_if_all_listings_destroyed

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def change_user_host_status
    host.host = true
    host.save
  end

  def change_host_status_if_all_listings_destroyed
    if Listing.all.none? {|l| l.host_id == host_id}
      host.host = false
      host.save
    end
  end




end
