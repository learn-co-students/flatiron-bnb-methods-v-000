describe Host do 
  it { should have_many(:guests).through(:listings) }
  it { should have_many(:reviews).through(:listings) }
end