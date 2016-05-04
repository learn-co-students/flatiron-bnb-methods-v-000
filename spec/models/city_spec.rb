describe City do
  describe 'associations' do
    it 'has a name' do
      expect(City.first.name).to eq('NYC')
    end

    it 'has many neighborhoods' do
      expect(City.first.neighborhoods).to eq([@nabe1, @nabe2, @nabe3])
    end
  end

  describe 'instance methods' do
    it 'knows about all the available listings given a date range' do
      expect(City.first.city_openings('2014-05-01', '2014-05-05')).to include(@listing2,@listing3)
    end
  end

  
end
