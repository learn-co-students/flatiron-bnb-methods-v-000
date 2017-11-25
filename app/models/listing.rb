class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  has_one :city, through: :neighborhood

  validates :address, :listing_type, :title, :address, :price, :description, :neighborhood_id, presence: true

  before_save :change_host_status

  after_destroy :change_host_status_false


  def change_host_status
    user = self.host
    user.host = true
    user.save
  end

  def change_host_status_false
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
