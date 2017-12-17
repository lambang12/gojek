require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:type) { create(:type) }
  let!(:user) { create(:user) }

  let(:valid_attributes) { attributes_for(:order, type_id: type.id) }

  let(:invalid_attributes) { attributes_for(:invalid_order) }
  let!(:order) { create(:order, user: user) }
  let(:order_id) { order.id }

  let(:valid_session) { {gojek_user_id: user.id} }

  describe "GET #index" do
    before { get :index, params: {}, session: valid_session }

    it "returns a success response" do
      expect(response).to be_success
    end

    it 'populates an array of all orders' do
      expect(assigns(:orders)).to match_array([order])
    end

    it 'renders the :index template' do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before { get :show, params: {id: order.to_param}, session: valid_session}

    it "returns a success response" do
      expect(response).to be_success
    end

    it 'assigns the requested order to @order' do
      expect(assigns(:order)).to eq(order)
    end

    it 'renders the :show template' do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    before { get :new, params: {}, session: valid_session }

    it "returns a success response" do
      expect(response).to be_success
    end

    it 'assigns a new Order to @order' do
      expect(assigns(:order)).to be_a_new(Order)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Order" do
        expect {
          post :create, params: {order: valid_attributes}, session: valid_session
        }.to change(Order, :count).by(1)
      end

      it "redirects to the created order" do
        post :create, params: {order: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Order.last)
      end
    end

    context "with invalid params" do
      it 'does not save the new order in the database' do
        expect{
          post :create, params: {order: invalid_attributes}, session: valid_session
        }.not_to change(Order, :count)
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {order: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end

      it 're-renders the :new template' do
        post :create, params: {order: invalid_attributes}, session: valid_session
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:order, status: 'Driver Assigned')
      }

      it "updates the requested order" do
        put :update, params: {id: order.to_param, order: new_attributes}, session: valid_session
        order.reload
        expect(order.status).to eq('Driver Assigned')
      end

      it "redirects to the order" do
        put :update, params: {id: order.to_param, order: valid_attributes}, session: valid_session
        expect(response).to redirect_to(order)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: order.to_param, order: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end

      it "does not change order's attributes" do
        put :update, params: {id: order.to_param, order: invalid_attributes}, session: valid_session
        order.reload
        expect(order.status).not_to eq('D')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested order" do
      expect {
        delete :destroy, params: {id: order.to_param}, session: valid_session
      }.to change(Order, :count).by(-1)
    end

    it "redirects to the orders list" do
      delete :destroy, params: {id: order.to_param}, session: valid_session
      expect(response).to redirect_to(orders_url)
    end
  end

end
