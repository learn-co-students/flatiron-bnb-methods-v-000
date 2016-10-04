class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  validates :address,:title, :description, :price, :listing_type, :neighborhood, presence: true
  #
  after_save :set_to_true
  # before_destroy :set_to_false

    def set_to_true
      # binding.pry
      # listing = Listing.find_by(host_id: false)
      # listing = Listing.where("host_id = ?", @host.id)
      binding.pry
       listing = Listing.new
        listing.host = true
      
    end
    #
    # def set_to_false
    #   Listing.new.host = false
    # end


end
