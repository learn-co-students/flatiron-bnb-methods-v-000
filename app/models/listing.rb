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
  validates :price, :neighborhood,   presence: true

  before_create :make_host_true
  after_destroy :make_host_false


  def make_host_true
    User.find(host_id).update(host:true)
  end

  def make_host_false
    if Listing.find_by(host_id: host_id) == nil
      User.find(host_id).update(host:false)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end



end
