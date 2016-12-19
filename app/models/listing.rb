class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :city
  belongs_to :host, :class_name => "User"
  belongs_to :guest, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  before_save :change_user_to_host
  before_destroy :change_host_to_user


  def change_user_to_host
    user = User.find(self.host_id)
    user.update(host: true)
  end


  def change_host_to_user
     user = User.find(self.host_id)
     if user.listings.size == 1
       user.update(host: false)
     end
   end

   def average_review_rating
     counted = self.reviews.all.count
     self.reviews.all.collect {|r| r.rating.to_f}.sum/counted.to_f
   end

end
