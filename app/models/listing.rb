class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations, :foreign_key => "guest_id"
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: :true


  before_create :change_host
  after_destroy :make_false 



  def change_host
   
    @user=User.find(self.host_id)
    @user.update(host: true)
  end

  def make_false
    @user=User.find(self.host_id)
    if @user.listings.count == 0
      @user.update(host: false)
    else
      @user.update(host: true)
    end
  end

  def average_review_rating
    self.reviews.average(:rating)
  end

  def check_availability(checkin, checkout)
    chkin = Date.parse(checkin)
    chkout = Date.parse(checkout)
    rezzy = []
    self.reservations.each do |x|

      rezzy << x if chkin.between?(x.checkin, x.checkout) || chkout.between?(x.checkin, x.checkout)
    end
    rezzy
  end

  
end
