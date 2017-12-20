require 'rails_helper'

RSpec.describe GopayController, type: :controller do
  let!(:user) { create(:user) }
  let(:valid_session) { {gojek_user_id: user.id} }

  describe 'GET topup' do
    it 'renders topup template with valid session' do
      get :topup, session: valid_session
      expect(response).to render_template(:topup)
    end

    it 'redirects to login page with invalid session' do
      get :topup
      expect(response).to redirect_to(login_path)
    end
  end

  # describe 'POST topup' do
  #   it 'should send form with id, type, and passphrase' do
  #     post :create, params: { id: user.id, type: 'customer', passphrase: '123456' }, session: valid_session
  #     expect(response).to redirect_to(user_path)
  #   end
  # end
end
