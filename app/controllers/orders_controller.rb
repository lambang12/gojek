class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    orders = @current_user.orders.all.paginate(page: params[:page], per_page: 10)
    @orders = OrderDecorator.decorate_collection(orders)
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = @current_user
    
    if @order.save
      redirect_to @order.decorate, notice: 'Order was successfully created.' 
    else
      render :new
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  private
    def set_order
      @order = @current_user.orders.find(params[:id]).decorate
    end

    def order_params
      params.require(:order).permit(:origin, :destination, :type_id, :payment_type, :status)
    end
end
