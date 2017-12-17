require 'rails_helper'

RSpec.describe GopayController, type: :controller do
  let(:valid_session) { {user_id: user.id} }
  let!(:user) { create(:user) }

  # how to test with database test in go??

  # describe 'POST create' do
  #   it 'should send form with id, type, and passphrase' do
  #     post :create, params: { id: user.id, type: 'customer', passphrase: '123456' }, session: valid_session
  #     expect(response).to redirect_to(user_path)
  #   end
  # end
end
