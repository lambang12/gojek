require 'rails_helper'

RSpec.describe Driver, type: :model do
  describe 'relations' do
    it { should have_many(:orders) }
  end
end
