class Review < ActiveRecord::Base
    belongs_to :reservation
    belongs_to :guest, :class_name => "User"

    validates :rating, presence:true
    validates :description, presence:true
    validate :comes_after_valid_checkout
    
    private
    def comes_after_valid_checkout
        if !(reservation && reservation.status == "accepted" && reservation.checkout < Date.today)
            errors.add(:review, "must apply to an accepted reservation that has passed") 
        end
    end
    
end
