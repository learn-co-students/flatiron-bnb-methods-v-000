require 'pry'
class Reservation < ActiveRecord::Base
    #    t.date     "checkin"
    #    t.date     "checkout"
    #    t.integer  "listing_id"
    #    t.integer  "guest_id"
    #    t.datetime "created_at",                     null: false
    #    t.datetime "updated_at",                     null: false
    #    t.string   "status",     default: "pending"

    belongs_to :listing
    belongs_to :guest, :class_name => "User"
    has_one :review

    validates :checkin, presence:true
    validates :checkout, presence:true
    validate :guest_is_not_host
    validate :available_at_checkin
    validate :available_at_checkout
    validate :checkin_is_before_checkout


    def duration
        ((checkout.noon-checkin.noon)/86400).round
    end

    def total_price
        duration * listing.price
    end


    private
    def guest_is_not_host
        if guest_id == listing.host.id
            errors.add(:guest, "cannot be host") 
        end
    end
    def available_at_checkin
        if !listing.reservations.empty? && checkin
            @is_available = listing.reservations.all? do |reservation|
                !(checkin > reservation.checkin && checkin < reservation.checkout)
            end
            if !@is_available 
                errors.add(:checkin, "date is taken") 
            end
        end
        return @is_available
    end
    def available_at_checkout
        if !listing.reservations.empty? && checkout
            @is_available = listing.reservations.all? do |reservation|
                !(checkout > reservation.checkin && checkout < reservation.checkout)
            end
            if !@is_available 
                errors.add(:checkout, "date is taken") 
            end
        end
        
    end
    def checkin_is_before_checkout
        if !(checkin && checkout && checkin < checkout)
            errors.add(:checkin, "must be before check-out") 
        end
    end
    def checkin_and_checkout_are_not_the_same
        if checkin && checkout && checkin.noon == checkout.noon 
            errors.add(:checkout, "cannot be the same as check-in") 
        end
    end


end
