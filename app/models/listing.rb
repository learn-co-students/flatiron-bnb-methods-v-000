class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: :true
  validates :listing_type, presence: :true
  validates :title, presence: :true
  validates :description, presence: :true
  validates :price, presence: :true
  validates :neighborhood_id, presence: :true 

  before_create do 
  	@user = User.find_by(id: host_id)
  	@user.host = true
  	@user.save
  end

  before_destroy do 
  	if @user.listings.count == 1
  		@user = User.find_by(id: host_id)
  		@user.host = false
  		@user.save
  	end
  end

  def average_review_rating
  	(self.reviews.map{|review| review.rating}.sum.to_f / self.reviews.count.to_f)
  end
end
