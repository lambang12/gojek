require 'rails_helper'

RSpec.describe OrderDecorator, :type => [:decorator, :helper] do
  let(:origin)  { 'Kolla Space Sabang'  }
  let(:destination)  { 'Monas' }

  let(:order) { create(:order, 
                     origin: origin, 
                     destination: destination) }

  let(:decorator) { order.decorate }

  describe '.distance_in_km' do
    it 'should return distance with km units' do
      expect(decorator.distance_in_km).to eq("1.0 km")
    end
  end

  describe '.idr_price' do
    it 'should return price in rupiah' do
      expect(decorator.idr_price).to eq("Rp 1.500,00")
    end
  end

  describe '.idr_fare' do
    it 'should return base fare in rupiah' do
      expect(decorator.idr_fare).to eq("Rp 1.500,00")
    end
  end

  describe '.order_date' do
    it 'should return created date month name and year' do
      expect(decorator.order_date).to eq(order.created_at.strftime("%d %B %Y %H:%M:%S"))
    end
  end
end
