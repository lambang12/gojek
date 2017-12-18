class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = @current_user.orders.all.decorate
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = @current_user

    # TODO if insufficient amount of gopay?????????
    

    respond_to do |format|
      if @order.save
        if @order.payment_type == "Go-Pay"
          pay_with_gopay
        end
        MessagingService.produce_order(@order)
        format.html { redirect_to @order.decorate, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = @current_user.orders.find(params[:id]).decorate
    end

    def order_params
      params.require(:order).permit(:origin, :destination, :type_id, :payment_type, :status)
    end

    def pay_with_gopay
      # if @order.valid?
        # puts @order.est_price
        response = GopayService.use(@current_user, @order.est_price)
        # if response[:Status] == 'OK'
        #   @current_user.update(gopay: response[:Account]["Amount"])
        #   true
        # else
        #   flash.now[:alert] = response[:Status]
        #   false
        # end
      # else
      #   false
      # end
    end
end
