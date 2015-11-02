describe Guest do 
  it { should have_many(:reviews).through(:reservations) }
  it { should have_many(:hosts).through(:reservations) }
end