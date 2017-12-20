require 'rails_helper'

RSpec.describe Type, type: :model do
  it 'has a valid factory' do
    expect(build(:type)).to be_valid
  end

  it 'is valid with a name and base fare' do
    expect(build(:type)).to be_valid
  end

  it 'is invalid without a name' do
    type = build(:type, name: nil)
    type.valid?
    expect(type.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a base fare' do
    type = build(:type, base_fare: nil)
    type.valid?
    expect(type.errors[:base_fare]).to include("can't be blank")
  end

  it 'is invalid with non-numerical base fare' do
    type = build(:type, base_fare: 'i00')
    type.valid?
    expect(type.errors[:base_fare]).to include("is not a number")
  end

  it 'is invalid with base fare <= 0' do
    type = build(:type, base_fare: -100)
    type.valid?
    expect(type.errors[:base_fare]).to include('must be greater than or equal to 0')
  end

  it 'is invalid with duplicate name' do
    type = create(:type, name: 'car')
    type2 = build(:type, name: 'Car')
    type2.valid?
    expect(type2.errors[:name]).to include('has already been taken')
  end

  describe "relations" do
    it { should have_many(:orders) }
  end
end
