class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  #delegate :city, :to => :neighborhood, :allow_nil => true


  validates :address, :neighborhood, :title, :description, :price, :listing_type, presence: true
 
  after_save :make_user_host
  after_destroy :make_host_user

  def average_review_rating
    self.reviews.average(:rating)
  end



  private

    def make_user_host
      @user = User.find_by(id: self.host_id)
      @user.host = true
      @user.save 
    end

    def make_host_user
      @user = User.find_by(id: self.host_id)
      if @user.listings.count > 0
        @user.host
      else
        @user.host = false
      end
      @user.save
    end

end
