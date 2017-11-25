class IsNotHostValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if Listing.find(record.listing_id).host_id == value
      record.errors[attribute] << "A host cannot reserve their own listing"
    end
  end
end
