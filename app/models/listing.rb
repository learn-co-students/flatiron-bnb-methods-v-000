class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  before_create :set_host
  after_destroy :unset_host

  def average_review_rating
    self.reviews.average(:rating)
  end

private

  def set_host
    User.find(self.host_id).update(host:true)
  end

  def unset_host
     if Listing.find_by(host_id: self.host_id) == nil
      User.find(self.host_id).update(host:false)
    end
  end

end
