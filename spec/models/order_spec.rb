require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'includes Validations' do
    expect(Order.ancestors.include? ActiveModel::Validations).to eq(true)
  end

  it 'has a valid factory' do
    expect(build(:order)).to be_valid
  end

  it 'is valid with origin, destination, order type, and payment_type' do
    expect(build(:order)).to be_valid
  end

  it 'is invalid without origin' do
    order = build(:order, origin: nil)
    order.valid?
    expect(order.errors[:origin]).to include("can't be blank")
  end

  it 'is invalid without destination' do
    order = build(:order, destination: nil)
    order.valid?
    expect(order.errors[:destination]).to include("can't be blank")
  end

  it 'is invalid without payment_type' do
    order = build(:order, payment_type: nil)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it 'is invalid with same origin and destination' do
    order = build(:order, origin: 'Kolla Space Sabang', destination: 'Kolla Space Sabang')
    order.valid?
    expect(order.errors[:destination]).to include("must be different with pickup location")
  end

  it 'can calculate distance between origin and distance' do
    order = create(:order)
    expect(order.distance).to be > 0
  end

  it 'saves base fare based on order type' do
    type = create(:type, name: 'car', base_fare: 2000)
    order = create(:order, type_id: type.id)
    expect(order.base_fare).to eq(2000)
  end

  it 'can calculate estimated price' do
    type = create(:type, name: 'car', base_fare: 2000)
    order = create(:order, type_id: type.id)
    expect(order.est_price).to eq(order.distance * order.base_fare)
  end

  it 'saves order with initial status (initialized)' do
    order = create(:order)
    expect(order.status).to eq('Initialized')
  end

  it 'is invalid with distance > 25 km' do
    order = build(:order, origin: 'grand indonesia', destination: 'stasiun bogor')
    order.valid?
    expect(order.errors[:destination]).to include("distance cannot exceed 25 km")
  end

  it 'saves order with initial driver nil' do
    order = create(:order)
    expect(order.driver_id).to be_nil
  end

  describe 'storing latitudes and longitudes' do
    context 'with valid address' do
      let!(:order) { create(:order, origin: 'Kolla Space Sabang', destination: 'Grand Indonesia') }

      it 'saves origin coordinates in the database' do
        expect(order.origin_coordinates.class).to eq(String)
      end

      it 'saves destination coordinates in the database' do
        expect(order.destination_coordinates.class).to eq(String)
      end
    end

    context 'with invalid address' do
      it 'is invalid with address not found' do
        order = build(:order, origin: 'xxsds')
        order.valid?
        expect(order.errors[:origin]).to include("address not found")
      end
    end
  end

  describe 'calculating distance' do
    it 'is invalid if no routes available from gmaps' do
      order = build(:order, origin: 'Kolla', destination: 'Pasaraya Blok M')
      order.valid?
      expect(order.errors[:base]).to include("Route between places not found")
    end
  end

  describe 'using Go-Pay' do
    it 'is valid with sufficient balance' do
      user = create(:user, gopay: 100000)
      order = build(:order, payment_type: "Go-Pay", user: user)
      expect(order).to be_valid
    end

    it 'is invalid with insufficient balance' do
      user = create(:user, gopay: 100)
      order = build(:order, payment_type: "Go-Pay", user: user)
      order.valid?
      expect(order.errors[:base]).to include("Insufficient amount of Go-Pay")
    end
  end

  describe 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:type) }
    it { should belong_to(:driver) }
  end
end
