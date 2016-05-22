class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  after_save :update_host_status
  after_destroy :update_host_status_all_delete

  def update_host_status
    # binding.pry
    user = User.find(self.host_id)
    user.host = true
    user.save
  end

  def update_host_status_all_delete
    if Listing.find_by(host_id: self.host_id).blank?
      user = User.find(self.host_id)
      user.host = false
      user.save
    end
  end


  def average_review_rating
    self.reviews.average(:rating)
  end


end
