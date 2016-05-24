class BeforeCheckoutValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value && record.checkout && value < record.checkout
      record.errors[attribute] << 'checkin must be before checkout'
    end
  end
end
