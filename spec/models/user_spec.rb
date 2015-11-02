# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  host       :boolean          default(FALSE)
#

describe User do
  describe 'associations' do

    it 'is valid' do
      expect(FactoryGirl.create :user).to be_valid
    end

    it { should have_many(:listings) }
    it { should have_many(:trips) }
    it { should have_many(:reservations).through(:listings) }
  end
end
