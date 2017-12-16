require 'rails_helper'

RSpec.describe Order, type: :model do
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

  it 'saves order with initial status I (initialized)' do
    order = create(:order)
    expect(order.status).to eq('I')
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

      it 'saves latitudes in the database' do
        expect(order.origin_latitude.class).to eq(Float)
      end

      it 'saves longitudes in the database' do
        expect(order.destination_longitude.class).to eq(Float)
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
end
