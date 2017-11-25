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
  validates :neighborhood_id, presence: true

  before_save :update_host_status
  before_destroy :downgrade_host


  def update_host_status
    host = User.find_by_id(self.host_id)
    host.host = true
    host.save
  end

  def downgrade_host
    host = User.find_by_id(self.host_id)
    if host.listings.count <= 1
      host.host = false
      host.save
    end
  end

  def average_review_rating
    (self.reviews.map {|review| review.rating}.sum.to_f / self.reviews.count.to_f)
  end
  
end
