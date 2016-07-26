class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :make_user_host
  before_destroy :undo_user_host

   def average_review_rating
    self.reviews.average(:rating)
   end

  private

  def make_user_host
    user = User.find(self.host_id)
    user.update(host: true)
  end

  def undo_user_host
    user = User.find(self.host_id)
    if user.listings.size <= 1
      user.update(host: false)
    end
  end

 


end
