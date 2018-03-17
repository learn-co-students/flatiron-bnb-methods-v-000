class CheckinComesBeforeCheckout < ActiveModel::Validator
  def validate(record)
    if record.checkin == nil || record.checkout == nil
      # do nothing
    elsif record.checkin >= record.checkout
      record.errors[:checkin] << 'Checkout must come after checkout.'
    end
  end
end
